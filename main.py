#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
yandex_webmaster_fetcher.py

Упрощённый и исправленный скрипт для выгрузки запросов из Yandex Webmaster API.

Использует:
- requests
- dataclasses
- локальное сохранение состояния с возобновлением
- CSV экспорт с нормализацией ключевых метрик
Альтернативный запуск: python main.py --access-token ваш_токен
"""
from dotenv import load_dotenv
import argparse
import csv
import json
import logging
import os
import signal
import sys
import time
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, Iterator, List, Optional, Tuple
from urllib.parse import quote

import requests


load_dotenv()
# --- Конфигурация ---

API_BASE = os.getenv("YANDEX_WEBMASTER_API_BASE", "https://api.webmaster.yandex.net/v4")
YANDEX_ACCESS_TOKEN = os.getenv("YANDEX_ACCESS_TOKEN", "")
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO").upper()
DEFAULT_REGION_ID = 225
DEFAULT_DEVICE_TYPE = "ALL"
MAX_LIMIT = 500
STATE_FILE_SUFFIX = ".state.json"

CSV_FIELDNAMES = [
    "host_id", "host_url", "query", "page_url", "date_from", "date_to",
    "region_id", "region_name", "device_type", "total_shows", "total_clicks",
    "ctr", "position", "demand", "order_by", "sample_time", "raw_json"
]

logging.basicConfig(
    level=LOG_LEVEL,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%dT%H:%M:%S%z"
)
logger = logging.getLogger("yandex-webmaster-fetcher")

_shutdown_requested = False


def shutdown_handler(signum, frame):
    global _shutdown_requested
    _shutdown_requested = True
    logger.info(f"Получен сигнал {signum}, завершение...")


signal.signal(signal.SIGINT, shutdown_handler)
signal.signal(signal.SIGTERM, shutdown_handler)


@dataclass
class HostInfo:
    host_id: str
    url: str
    verified: bool = False
    raw: Dict[str, Any] = field(default_factory=dict)
    display_id: str = ""


@dataclass
class FetchConfig:
    region: int = DEFAULT_REGION_ID
    device_type: str = DEFAULT_DEVICE_TYPE
    limit: int = 100  # в API лимит max 500 — но берём 100 по умолчанию
    date_from: Optional[str] = None
    date_to: Optional[str] = None
    export_type: str = "queries"
    order_by: str = "TOTAL_SHOWS"  # можно разрешить менять
    
    def __post_init__(self):
        """Устанавливаем даты по умолчанию, если не указаны"""
        if not self.date_from or not self.date_to:
            from datetime import datetime, timedelta
            today = datetime.now().date()
            week_ago = today - timedelta(days=7)
            if not self.date_from:
                self.date_from = week_ago.strftime("%Y-%m-%d")
            if not self.date_to:
                self.date_to = today.strftime("%Y-%m-%d")


@dataclass
class StateManager:
    path: Path
    state: Dict[str, Any] = field(default_factory=dict)

    def load_state(self):
        if self.path.exists():
            try:
                with self.path.open("r", encoding="utf-8") as f:
                    self.state = json.load(f)
                    logger.debug(f"Загружено состояние: {self.state}")
            except Exception as e:
                logger.warning(f"Не удалось загрузить state-файл {self.path}: {e}")
                self.state = {}
        else:
            self.state = {}

    def save(self, offset: int, total_fetched: int):
        self.state["offset"] = offset
        self.state["total_fetched"] = total_fetched
        self.state["updated_at"] = datetime.now(timezone.utc).isoformat()

        tmp_path = self.path.with_suffix(self.path.suffix + ".tmp")
        try:
            with tmp_path.open("w", encoding="utf-8") as f:
                json.dump(self.state, f, ensure_ascii=False, indent=2)
            os.replace(tmp_path, self.path)
            logger.debug(f"Состояние сохранено offset={offset}, total={total_fetched}")
        except Exception as e:
            logger.error(f"Ошибка записи state-файла: {e}")


class YandexWebmasterClient:
    EXPORT_ENDPOINTS = {
        "popular": "search-queries/popular",
        "queries": "search-queries/popular",
        "detailed": "search-queries/popular",
        "all-queries": "search-queries/popular",
    }

    def __init__(self, access_token: str, base_url: str = API_BASE, timeout: int = 30):
        self.access_token = access_token
        self.base_url = base_url.rstrip("/")
        self.timeout = timeout
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"OAuth {self.access_token}",
            "Accept": "application/json",
            "User-Agent": "YandexWebmasterFetcher/1.0"
        })
        self.user_id: Optional[str] = None
        self.current_host: Optional[HostInfo] = None

    def _url(self, path: str) -> str:
        return f"{self.base_url}/{path.lstrip('/')}"

    def _request(self, method: str, path: str, params=None, json_body=None, retries=3) -> requests.Response:
        url = self._url(path)
        last_exception = None
        for attempt in range(retries):
            try:
                resp = self.session.request(method, url, params=params, json=json_body, timeout=self.timeout)
                if resp.status_code == 429:
                    retry_after = int(resp.headers.get('Retry-After', 1))
                    logger.warning(f"429 Too Many Requests, retry через {retry_after} сек")
                    time.sleep(retry_after)
                    continue
                resp.raise_for_status()
                return resp
            except requests.RequestException as e:
                last_exception = e
                logger.warning(f"Ошибка HTTP запроса (попытка {attempt + 1}/{retries}): {e}")
                time.sleep(2 ** attempt)
        if last_exception:
            raise last_exception
        raise RuntimeError("Неудачные попытки запроса")

    def get_user_info(self) -> dict:
        resp = self._request("GET", "/user")
        return resp.json()

    def get_user_id(self, user_info: dict) -> Optional[str]:
        # Стандартный ключ API
        return str(user_info.get("user_id") or user_info.get("id") or "")

    def get_hosts(self, user_id: str) -> List[HostInfo]:
        resp = self._request("GET", f"/user/{user_id}/hosts")
        j = resp.json()

        hosts = []
        for h in j.get("hosts", []):
            # API возвращает host_id в формате "https:domain:port"
            # Это и есть правильный идентификатор для использования в запросах
            host_id = h.get("host_id") or h.get("id") or ""
            url = h.get("ascii_host_url") or h.get("unicode_host_url") or h.get("url") or ""
            verified = h.get("verified", False)
            
            logger.debug(f"Host из API: host_id={host_id}, url={url}")
            
            hosts.append(HostInfo(
                host_id=host_id,  # Используем оригинальный host_id
                url=url,
                verified=verified,
                raw=h,
                display_id=host_id  # display_id = host_id
            ))
        return hosts

    def build_export_path(self, user_id: str, host_id: str, export_type: str) -> str:
        """Строит путь для экспорта данных с правильным кодированием host_id"""
        endpoint = self.EXPORT_ENDPOINTS.get(export_type, "search-queries/all")
        
        # host_id приходит в формате "https:domain:port" и его нужно кодировать полностью
        encoded_host_id = quote(host_id, safe='')
        
        logger.debug(f"Исходный host_id: {host_id}, закодированный: {encoded_host_id}")
        return f"/user/{user_id}/hosts/{encoded_host_id}/{endpoint}"

    def fetch_data_page(self, path: str, params: dict) -> dict:
        resp = self._request("GET", path, params=params)
        return resp.json()


class Normalizer:
    @staticmethod
    def extract_indicators(item: Dict[str, Any]) -> Dict[str, Any]:
        """Извлекает метрики из элемента данных API"""
        ind = item.get("indicators") or {}
        
        # API возвращает метрики в верхнем регистре
        shows = (ind.get("TOTAL_SHOWS") or 
                ind.get("shows") or 
                ind.get("impressions") or 
                ind.get("total_shows") or 
                item.get("TOTAL_SHOWS") or
                item.get("shows") or 0)
        
        clicks = (ind.get("TOTAL_CLICKS") or 
                 ind.get("clicks") or 
                 ind.get("total_clicks") or 
                 item.get("TOTAL_CLICKS") or
                 item.get("clicks") or 0)
        
        ctr = (ind.get("CTR") or 
              ind.get("ctr") or 
              item.get("CTR") or
              item.get("ctr"))
        
        avg_pos = (ind.get("AVG_SHOW_POSITION") or 
                  ind.get("AVG_CLICK_POSITION") or
                  ind.get("avg_show_position") or 
                  ind.get("avg_position") or 
                  ind.get("position") or
                  item.get("AVG_SHOW_POSITION") or
                  item.get("position"))
        
        demand = (ind.get("DEMAND") or 
                 ind.get("demand") or 
                 ind.get("popularity") or 
                 item.get("DEMAND") or
                 item.get("demand"))
        
        page_url = (ind.get("page") or 
                   item.get("page") or 
                   item.get("url") or 
                   ind.get("landing_url") or "")

        # Приведение типов
        try:
            shows = float(shows)  # API может возвращать float
            shows = int(shows)
        except Exception:
            shows = 0
        try:
            clicks = float(clicks)
            clicks = int(clicks)
        except Exception:
            clicks = 0
        try:
            avg_pos = float(avg_pos) if avg_pos is not None else ""
        except Exception:
            avg_pos = ""

        try:
            ctr = float(ctr) if ctr is not None else None
        except Exception:
            ctr = None

        return {
            "shows": shows,
            "clicks": clicks,
            "ctr": ctr,
            "avg_position": avg_pos,
            "demand": demand or "",
            "page": page_url
        }

    @staticmethod
    def to_row(item: Dict[str, Any], host: HostInfo, config: FetchConfig, region_name: str, order_by: str) -> Dict[str, Any]:
        ind = Normalizer.extract_indicators(item)

        shows = ind["shows"]
        clicks = ind["clicks"]

        ctr = ind["ctr"]
        if ctr is None:
            ctr = round(clicks / shows, 6) if shows else 0

        query = item.get("query_text") or item.get("query") or item.get("request") or item.get("text") or ""

        row = {
            "host_id": host.display_id or host.host_id,
            "host_url": host.url,
            "query": query,
            "page_url": ind["page"],
            "date_from": config.date_from or "",
            "date_to": config.date_to or "",
            "region_id": config.region,
            "region_name": region_name,
            "device_type": config.device_type,
            "total_shows": shows,
            "total_clicks": clicks,
            "ctr": ctr,
            "position": ind["avg_position"],
            "demand": ind["demand"],
            "order_by": order_by,
            "sample_time": datetime.now(timezone.utc).isoformat(),
            "raw_json": json.dumps(item, ensure_ascii=False)
        }

        # Приведение None к пустым строкам
        for k, v in row.items():
            if v is None:
                row[k] = ""

        return row


class CSVWriter:
    def __init__(self, path: Path):
        self.path = path
        self.file = None
        self.writer = None
        self.open_file()

    def open_file(self):
        file_exists = self.path.exists()
        self.file = self.path.open("a", newline="", encoding="utf-8")
        self.writer = csv.DictWriter(self.file, fieldnames=CSV_FIELDNAMES)
        if not file_exists or self.file.tell() == 0:
            self.writer.writeheader()

    def write_rows(self, rows: List[Dict[str, Any]]):
        if rows:
            self.writer.writerows(rows)
            self.file.flush()

    def close(self):
        if self.file:
            self.file.close()
            self.file = None


class DataFetcher:
    def __init__(self, client: YandexWebmasterClient, config: FetchConfig, state_manager: StateManager, region_name: str = "Russia"):
        self.client = client
        self.config = config
        self.state_manager = state_manager
        self.region_name = region_name

    def fetch_all(self) -> Iterator[List[Dict[str, Any]]]:
        offset = int(self.state_manager.state.get("offset", 0))
        total_fetched = int(self.state_manager.state.get("total_fetched", 0))

        if not self.client.user_id or not self.client.current_host:
            raise RuntimeError("user_id или current_host не заданы")

        path = self.client.build_export_path(self.client.user_id, self.client.current_host.host_id, self.config.export_type)
        order_by = self.config.order_by

        logger.info(f"Начинаем выгрузку: host={self.client.current_host.display_id} offset={offset}")
        logger.debug(f"Путь запроса: {path}")

        # Список всех индикаторов, которые нужно получить
        indicators_to_fetch = ["TOTAL_SHOWS", "TOTAL_CLICKS", "AVG_SHOW_POSITION", "CTR"]
        
        while not _shutdown_requested:
            # Создаем базовые параметры
            base_params = {
                "limit": self.config.limit,
                "offset": offset,
                "order_by": order_by,
                "device_type_indicator": self.config.device_type,
            }
            if self.config.date_from:
                base_params["date_from"] = self.config.date_from
            if self.config.date_to:
                base_params["date_to"] = self.config.date_to

            # Собираем данные по всем индикаторам
            combined_data = {}
            
            for indicator in indicators_to_fetch:
                params = base_params.copy()
                params["query_indicator"] = indicator
                
                logger.debug(f"Запрос с индикатором {indicator}: {path} с параметрами {params}")
                
                try:
                    raw_json = self.client.fetch_data_page(path, params)
                    
                    # Сохраняем первый ответ для анализа
                    if offset == 0 and indicator == "TOTAL_SHOWS":
                        debug_file = Path("api_response_debug.json")
                        with debug_file.open("w", encoding="utf-8") as f:
                            json.dump(raw_json, f, ensure_ascii=False, indent=2)
                        logger.info(f"Первый ответ API сохранен в {debug_file}")
                    
                    items, _ = self.extract_items_and_pagination(raw_json, offset)
                    
                    # Объединяем индикаторы
                    for item in items:
                        query_id = item.get("query_id")
                        if query_id not in combined_data:
                            combined_data[query_id] = item.copy()
                        else:
                            # Добавляем индикаторы к существующему элементу
                            item_indicators = item.get("indicators", {})
                            combined_data[query_id]["indicators"].update(item_indicators)
                    
                except Exception as e:
                    logger.error(f"Ошибка запроса для индикатора {indicator}: {e}")
                    break
                
                # Небольшая пауза между запросами
                time.sleep(0.2)
            
            # Проверяем, есть ли данные
            if not combined_data:
                logger.info("Данные закончились")
                break
            
            items = list(combined_data.values())
            logger.info(f"Получено {len(items)} элементов с полными метриками, offset={offset}")
            yield items

            offset += len(items)
            total_fetched += len(items)
            self.state_manager.save(offset, total_fetched)

            time.sleep(0.5)

    @staticmethod
    def extract_items_and_pagination(raw: Any, offset: int, limit: int = MAX_LIMIT) -> Tuple[List[Dict[str, Any]], Optional[int]]:
        items = []
        next_offset = None

        # Стандартные поля с данными на разных типах API
        possible_fields = ["queries", "popular_queries", "search_queries", "rows", "items", "data", "results"]

        if isinstance(raw, dict):
            for field in possible_fields:
                if field in raw and isinstance(raw[field], list):
                    items = raw[field]
                    break
            if not items:
                for v in raw.values():
                    if isinstance(v, list):
                        items = v
                        break

            total_count = raw.get("total_count") or raw.get("count")
            if total_count is not None and isinstance(total_count, int):
                if offset + len(items) < total_count:
                    next_offset = offset + len(items)
            elif "next_offset" in raw:
                next_offset = raw.get("next_offset")
            else:
                if len(items) == limit:
                    next_offset = offset + len(items)

        elif isinstance(raw, list):
            items = raw
            if len(items) == limit:
                next_offset = offset + len(items)

        return items, next_offset


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Yandex.Webmaster Query Fetcher")
    parser.add_argument("--host-id", help="Host ID или URL сайта")
    parser.add_argument("--access-token", help="OAuth access token (можно указать через YANDEX_ACCESS_TOKEN)")
    parser.add_argument("--export", default="queries", choices=["queries", "popular", "detailed", "all-queries"], help="Тип выгрузки")
    parser.add_argument("--region", type=int, default=DEFAULT_REGION_ID, help="Region ID")
    parser.add_argument("--region-name", default="Russia", help="Название региона для CSV")
    parser.add_argument("--device-type", default=DEFAULT_DEVICE_TYPE, help="Тип устройства (DESKTOP, MOBILE, TABLET, ALL)")
    parser.add_argument("--limit", type=int, default=100, help="Лимит на страницу (макс 500)")
    parser.add_argument("--date-from", help="Дата начала формата YYYY-MM-DD")
    parser.add_argument("--date-to", help="Дата окончания формата YYYY-MM-DD")
    parser.add_argument("--output-file", default="queries.csv", help="Файл для вывода CSV")
    parser.add_argument("--state-file", help="Файл состояния для резюме выгрузки")
    parser.add_argument("--debug", action="store_true", help="Включить отладочный вывод")
    parser.add_argument("--no-interactive", action="store_true", help="Не использовать интерактивный выбор")
    return parser.parse_args()


def choose_host_interactive(hosts: List[HostInfo]) -> HostInfo:
    if not hosts:
        logger.error("Сайтов не найдено")
        sys.exit(1)
    if len(hosts) == 1:
        return hosts[0]

    print("\nДоступные сайты:")
    for i, h in enumerate(hosts, 1):
        print(f"{i}. id={h.display_id} url={h.url} verified={h.verified}")

    while True:
        try:
            choice = input("\nВыберите сайт по номеру: ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\nОтмена действия.")
            sys.exit(1)
        if choice.isdigit():
            idx = int(choice) - 1
            if 0 <= idx < len(hosts):
                return hosts[idx]
        print(f"Введите число от 1 до {len(hosts)}")


def validate_date(date_str: Optional[str]) -> Optional[str]:
    if not date_str:
        return None
    try:
        datetime.strptime(date_str, "%Y-%m-%d")
        return date_str
    except ValueError:
        logger.error(f"Неверный формат даты: {date_str}, ожидается YYYY-MM-DD")
        sys.exit(1)


def main():
    args = parse_args()

    if args.debug:
        logger.setLevel(logging.DEBUG)
        logging.getLogger("requests").setLevel(logging.WARNING)

    access_token = args.access_token or YANDEX_ACCESS_TOKEN
    if not access_token:
        logger.error("Не указан access token (через --access-token или YANDEX_ACCESS_TOKEN)")
        sys.exit(1)

    if args.limit < 1 or args.limit > MAX_LIMIT:
        logger.warning(f"Лимит {args.limit} превышает допустимые значения, будет установлен {MAX_LIMIT}")
        args.limit = MAX_LIMIT

    args.date_from = validate_date(args.date_from)
    args.date_to = validate_date(args.date_to)

    client = YandexWebmasterClient(access_token=access_token)

    try:
        user_info = client.get_user_info()
        logger.debug(f"Информация о пользователе получена: {user_info}")
    except Exception as e:
        logger.error(f"Ошибка получения информации о пользователе: {e}")
        sys.exit(1)

    user_id = client.get_user_id(user_info)
    if not user_id:
        logger.error("Не удалось определить user_id")
        sys.exit(1)
    client.user_id = user_id

    try:
        hosts = client.get_hosts(user_id)
        logger.info(f"Найдено сайтов: {len(hosts)}")
    except Exception as e:
        logger.error(f"Ошибка получения списка сайтов: {e}")
        sys.exit(1)

    host = None
    if args.host_id:
        for h in hosts:
            if args.host_id in (h.host_id, h.display_id, h.url):
                host = h
                break
        if not host:
            logger.error(f"Сайт '{args.host_id}' не найден")
            if args.no_interactive:
                sys.exit(1)
            host = choose_host_interactive(hosts)
    else:
        if args.no_interactive:
            logger.error("Нужно указать --host-id, если нет интерактивного выбора")
            sys.exit(1)
        host = choose_host_interactive(hosts)

    logger.info(f"Выбран сайт: {host.display_id} ({host.url})")
    client.current_host = host

    fetch_config = FetchConfig(
        region=args.region,
        device_type=args.device_type,
        limit=args.limit,
        date_from=args.date_from,
        date_to=args.date_to,
        export_type=args.export,
        order_by="TOTAL_SHOWS"
    )

    output_path = Path(args.output_file)
    state_path = Path(args.state_file) if args.state_file else output_path.with_suffix(output_path.suffix + STATE_FILE_SUFFIX)

    state_manager = StateManager(state_path)
    state_manager.load_state()

    fetcher = DataFetcher(client, fetch_config, state_manager, region_name=args.region_name)
    writer = CSVWriter(output_path)

    total_rows = 0

    try:
        for chunk_items in fetcher.fetch_all():
            normalized_rows = [Normalizer.to_row(item, host, fetch_config, args.region_name, fetch_config.order_by) for item in chunk_items]

            writer.write_rows(normalized_rows)
            total_rows += len(normalized_rows)
            logger.info(f"Всего записано строк: {total_rows}")

    except KeyboardInterrupt:
        logger.info("Выгрузка прервана пользователем")
    except Exception as e:
        logger.error(f"Произошла ошибка: {e}")
        if args.debug:
            import traceback
            logger.debug(traceback.format_exc())
        sys.exit(1)
    finally:
        writer.close()

    logger.info(f"Выгрузка завершена успешно, всего строк: {total_rows}")


if __name__ == "__main__":
    main()