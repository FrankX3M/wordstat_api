#!/usr/bin/env bash
set -e

PROJECT_NAME="webmaster_bot"

echo "=========================================="
echo "Yandex Webmaster Telegram Bot v3.0"
echo "Полная версия с улучшениями"
echo "=========================================="

# ============================================================================
# Создание структуры директорий
# ============================================================================
echo "📁 Создаем структуру проекта..."
mkdir -p $PROJECT_NAME/{handlers,services,database,keyboards,utils,exports,states,logs,tests}

# ============================================================================
# .env.example
# ============================================================================
cat > $PROJECT_NAME/.env.example <<'EOF'
# Telegram Bot Token (получить у @BotFather)
TELEGRAM_BOT_TOKEN=YOUR_TELEGRAM_BOT_TOKEN

# Yandex OAuth Token (https://oauth.yandex.ru/)
YANDEX_ACCESS_TOKEN=YOUR_YANDEX_ACCESS_TOKEN

# База данных (ВАЖНО: используйте sqlite+aiosqlite для асинхронной работы)
DATABASE_URL=sqlite+aiosqlite:///webmaster_bot.db

# Лимиты и настройки
MAX_EXPORT_ROWS=10000
DEFAULT_PAGE_SIZE=100
RETRY_ATTEMPTS=3
RETRY_DELAY=5

# Логирование (DEBUG, INFO, WARNING, ERROR)
LOG_LEVEL=INFO
LOG_TO_FILE=True
LOG_TO_CONSOLE=True

# Дополнительные настройки
ADMIN_USER_IDS=123456789,987654321
ENABLE_ANALYTICS=True
CACHE_TTL=3600
EOF

# ============================================================================
# requirements.txt
# ============================================================================
cat > $PROJECT_NAME/requirements.txt <<'EOF'
# Telegram Bot Framework
aiogram==3.22.0

# HTTP клиент
aiohttp>=3.9.0
requests>=2.31.0

# База данных
sqlalchemy>=2.0.0
aiosqlite>=0.19.0

# Утилиты
python-dotenv>=1.0.0
pandas>=2.1.0

# Логирование
python-json-logger>=2.0.0
colorlog>=6.8.0

# Дата и время
python-dateutil>=2.8.0

# Excel экспорты
openpyxl>=3.1.0

# Кэширование
aiocache>=0.12.2
EOF

# ============================================================================
# .gitignore
# ============================================================================
cat > $PROJECT_NAME/.gitignore <<'EOF'
# Environment
.env
*.env
!.env.example

# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual Environment
venv/
ENV/
env/

# Database
*.db
*.sqlite
*.sqlite3

# Logs
logs/*.log
*.log

# Exports
exports/*.csv
exports/*.xlsx
exports/*.json

# States
states/*.json

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db
EOF

# ============================================================================
# README.md
# ============================================================================
cat > $PROJECT_NAME/README.md <<'EOF'
# 🤖 Yandex Webmaster Telegram Bot v3.0

Telegram бот для работы с API Yandex Webmaster с полным функционалом экспорта данных и аналитики.

## 🚀 Возможности

- ✅ Просмотр списка сайтов
- ✅ Детальная информация о каждом сайте
- ✅ Экспорт популярных запросов
- ✅ История запросов с фильтрацией
- ✅ Расширенная аналитика
- ✅ Многоформатный экспорт (CSV, Excel, JSON)
- ✅ Прогресс-бары для длительных операций
- ✅ Детальное логирование
- ✅ Диагностика системы

## 📋 Требования

- Python 3.9+
- Telegram Bot Token
- Yandex OAuth Token с правами `webmaster:read`

## 🛠️ Установка

1. Клонируйте репозиторий или распакуйте архив
2. Создайте виртуальное окружение:
```bash
python -m venv venv
source venv/bin/activate  # Linux/Mac
# или
venv\Scripts\activate  # Windows
```

3. Установите зависимости:
```bash
pip install -r requirements.txt
```

4. Скопируйте `.env.example` в `.env`:
```bash
cp .env.example .env
```

5. Отредактируйте `.env` и укажите токены:
- `TELEGRAM_BOT_TOKEN` - получите у @BotFather
- `YANDEX_ACCESS_TOKEN` - получите на https://oauth.yandex.ru/

6. Запустите бота:
```bash
python bot.py
```

## 📖 Использование

### Команды бота:

- `/start` - Начало работы и главное меню
- `/help` - Справка по командам
- `/hosts` - Список ваших сайтов
- `/auth` - Информация об авторизации
- `/token` - Проверка OAuth токена
- `/diagnose` - Диагностика системы
- `/stats` - Статистика использования бота

### Основной workflow:

1. Запустите бота командой `/start`
2. Выберите "🌐 Мои сайты"
3. Выберите нужный сайт из списка
4. Нажмите "📊 Создать экспорт"
5. Выберите тип экспорта и настройте параметры
6. Дождитесь завершения и скачайте файл

## 🔧 Конфигурация

Все настройки в файле `.env`:

- `MAX_EXPORT_ROWS` - максимальное количество строк в экспорте (по умолчанию 10000)
- `DEFAULT_PAGE_SIZE` - размер страницы при запросах к API (по умолчанию 100)
- `LOG_LEVEL` - уровень логирования (DEBUG, INFO, WARNING, ERROR)
- `RETRY_ATTEMPTS` - количество попыток при ошибках (по умолчанию 3)
- `RETRY_DELAY` - задержка между попытками в секундах (по умолчанию 5)

## 📁 Структура проекта

```
webmaster_bot/
├── bot.py              # Главный файл запуска
├── config.py           # Конфигурация
├── handlers/           # Обработчики команд
│   ├── __init__.py
│   ├── start.py
│   ├── hosts.py
│   ├── export.py
│   ├── auth.py
│   └── stats.py
├── services/           # Сервисы
│   ├── __init__.py
│   ├── api.py         # Yandex API
│   └── export.py      # Экспорт данных
├── database/           # База данных
│   ├── __init__.py
│   └── models.py
├── keyboards/          # Клавиатуры
│   ├── __init__.py
│   └── menu.py
├── utils/             # Утилиты
│   ├── __init__.py
│   ├── logger.py
│   └── helpers.py
├── states/            # FSM состояния
│   ├── __init__.py
│   └── export.py
├── exports/           # Экспортированные файлы
├── logs/              # Логи
└── tests/             # Тесты
```

## 🐛 Отладка

### Проверка токена:
```bash
/token
```

### Полная диагностика:
```bash
/diagnose
```

### Логи:
Все логи сохраняются в директории `logs/` с ротацией файлов.

## 🔐 Безопасность

- ⚠️ Никогда не коммитьте файл `.env` в репозиторий
- ⚠️ Храните токены в безопасном месте
- ⚠️ Используйте HTTPS для production
- ⚠️ Регулярно обновляйте зависимости

## 📝 Лицензия

MIT License

## 🤝 Поддержка

При возникновении проблем:
1. Проверьте логи в `logs/`
2. Используйте команду `/diagnose`
3. Проверьте конфигурацию в `.env`

## 🔄 Обновления

v3.0 - Полная версия с улучшенной архитектурой
- Добавлены все недостающие файлы
- Улучшена обработка ошибок
- Добавлена детальная диагностика
- Расширены возможности экспорта
EOF

# ============================================================================
# config.py
# ============================================================================
cat > $PROJECT_NAME/config.py <<'EOF'
import os
import sys
from pathlib import Path
from dotenv import load_dotenv

# Загрузка .env
load_dotenv()

# ============================================================================
# TELEGRAM
# ============================================================================
TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")
if not TELEGRAM_BOT_TOKEN or TELEGRAM_BOT_TOKEN == "YOUR_TELEGRAM_BOT_TOKEN":
    print("❌ ОШИБКА: TELEGRAM_BOT_TOKEN не установлен!")
    print("📝 Отредактируйте файл .env и укажите токен от @BotFather")
    sys.exit(1)

# ============================================================================
# YANDEX WEBMASTER API
# ============================================================================
YANDEX_ACCESS_TOKEN = os.getenv("YANDEX_ACCESS_TOKEN")
if not YANDEX_ACCESS_TOKEN or YANDEX_ACCESS_TOKEN == "YOUR_YANDEX_ACCESS_TOKEN":
    print("❌ ОШИБКА: YANDEX_ACCESS_TOKEN не установлен!")
    print("📝 Получите OAuth токен на https://oauth.yandex.ru/")
    print("📝 Отредактируйте файл .env и укажите токен")
    sys.exit(1)

# Валидация токена
if len(YANDEX_ACCESS_TOKEN) < 20:
    print("⚠️ ПРЕДУПРЕЖДЕНИЕ: Токен выглядит слишком коротким")
    print(f"   Длина: {len(YANDEX_ACCESS_TOKEN)} символов")

# ============================================================================
# База данных
# ============================================================================
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite+aiosqlite:///webmaster_bot.db")

# ============================================================================
# API настройки
# ============================================================================
API_BASE_URL = "https://api.webmaster.yandex.net/v4"
API_TIMEOUT = 30
MAX_RETRIES = int(os.getenv("RETRY_ATTEMPTS", "3"))
RETRY_DELAY = int(os.getenv("RETRY_DELAY", "5"))

# ============================================================================
# Логирование
# ============================================================================
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
LOG_TO_FILE = os.getenv("LOG_TO_FILE", "True").lower() == "true"
LOG_TO_CONSOLE = os.getenv("LOG_TO_CONSOLE", "True").lower() == "true"

# ============================================================================
# Лимиты выгрузки
# ============================================================================
MAX_EXPORT_ROWS = int(os.getenv("MAX_EXPORT_ROWS", "10000"))
DEFAULT_PAGE_SIZE = int(os.getenv("DEFAULT_PAGE_SIZE", "100"))
MAX_PAGE_SIZE = 500

# ============================================================================
# Административные настройки
# ============================================================================
ADMIN_USER_IDS_STR = os.getenv("ADMIN_USER_IDS", "")
ADMIN_USER_IDS = [int(uid.strip()) for uid in ADMIN_USER_IDS_STR.split(",") if uid.strip()]

# ============================================================================
# Дополнительные настройки
# ============================================================================
ENABLE_ANALYTICS = os.getenv("ENABLE_ANALYTICS", "True").lower() == "true"
CACHE_TTL = int(os.getenv("CACHE_TTL", "3600"))

# ============================================================================
# Директории
# ============================================================================
BASE_DIR = Path(__file__).parent
EXPORTS_DIR = BASE_DIR / "exports"
STATES_DIR = BASE_DIR / "states"
LOGS_DIR = BASE_DIR / "logs"

# Создание директорий
EXPORTS_DIR.mkdir(exist_ok=True)
STATES_DIR.mkdir(exist_ok=True)
LOGS_DIR.mkdir(exist_ok=True)

# ============================================================================
# Константы
# ============================================================================
DEVICE_TYPES = ["ALL", "DESKTOP", "MOBILE", "TABLET"]

EXPORT_TYPES = {
    "popular": "Популярные запросы",
    "history": "История запросов",
    "history_all": "Расширенная история",
    "analytics": "Детальная аналитика",
    "enhanced": "Расширенный экспорт"
}

ORDER_BY_OPTIONS = [
    "TOTAL_SHOWS",
    "TOTAL_CLICKS",
    "CTR",
    "AVG_POSITION",
    "DEMAND"
]

# Форматы экспорта
EXPORT_FORMATS = ["csv", "xlsx", "json"]

# ============================================================================
# Версия
# ============================================================================
VERSION = "3.0.0"
BOT_NAME = "Yandex Webmaster Bot"

# ============================================================================
# Диагностическая информация
# ============================================================================
if __name__ == "__main__":
    print(f"✅ {BOT_NAME} v{VERSION}")
    print(f"✅ Конфигурация загружена успешно")
    print(f"📊 API Base URL: {API_BASE_URL}")
    print(f"📊 Database: {DATABASE_URL}")
    print(f"📊 Log Level: {LOG_LEVEL}")
    print(f"📊 Exports Dir: {EXPORTS_DIR}")
    print(f"📊 Admin Users: {len(ADMIN_USER_IDS)}")
EOF

# ============================================================================
# bot.py - ГЛАВНЫЙ ФАЙЛ
# ============================================================================
cat > $PROJECT_NAME/bot.py <<'EOF'
import asyncio
import sys
from pathlib import Path

from aiogram import Bot, Dispatcher
from aiogram.client.default import DefaultBotProperties
from aiogram.enums import ParseMode
from aiogram.fsm.storage.memory import MemoryStorage

# Настройка путей
sys.path.insert(0, str(Path(__file__).parent))

from config import TELEGRAM_BOT_TOKEN, VERSION, BOT_NAME
from utils.logger import setup_logger
from database import init_db

# Импорт всех роутеров
from handlers.start import router as start_router
from handlers.hosts import router as hosts_router
from handlers.export import router as export_router
from handlers.auth import router as auth_router
from handlers.stats import router as stats_router

logger = setup_logger(__name__)


async def on_startup(bot: Bot):
    """Действия при запуске бота"""
    logger.info("=" * 60)
    logger.info(f"🚀 {BOT_NAME} v{VERSION} starting...")
    logger.info("=" * 60)
    
    # Инициализация базы данных
    try:
        await init_db()
        logger.info("✅ Database initialized")
    except Exception as e:
        logger.error(f"❌ Database initialization failed: {e}")
        raise
    
    # Получение информации о боте
    try:
        bot_info = await bot.get_me()
        logger.info(f"✅ Bot connected: @{bot_info.username}")
        logger.info(f"   Bot ID: {bot_info.id}")
        logger.info(f"   Bot Name: {bot_info.full_name}")
    except Exception as e:
        logger.error(f"❌ Failed to get bot info: {e}")
        raise
    
    logger.info("✅ Bot is ready to accept messages")
    logger.info("=" * 60)


async def on_shutdown(bot: Bot):
    """Действия при остановке бота"""
    logger.info("=" * 60)
    logger.info("🛑 Bot is shutting down...")
    logger.info("=" * 60)
    
    # Закрытие сессии бота
    await bot.session.close()
    
    logger.info("✅ Bot stopped successfully")


async def main():
    """Главная функция запуска бота"""
    
    # Создание бота и диспетчера
    bot = Bot(
        token=TELEGRAM_BOT_TOKEN,
        default=DefaultBotProperties(parse_mode=ParseMode.HTML)
    )
    
    dp = Dispatcher(storage=MemoryStorage())
    
    # Регистрация роутеров
    dp.include_router(start_router)
    dp.include_router(hosts_router)
    dp.include_router(export_router)
    dp.include_router(auth_router)
    dp.include_router(stats_router)
    
    # Регистрация startup/shutdown хуков
    dp.startup.register(on_startup)
    dp.shutdown.register(on_shutdown)
    
    try:
        # Запуск polling
        await dp.start_polling(
            bot,
            allowed_updates=dp.resolve_used_update_types(),
            drop_pending_updates=True
        )
    except KeyboardInterrupt:
        logger.info("⚠️ Received keyboard interrupt")
    except Exception as e:
        logger.error(f"❌ Critical error: {e}")
        raise
    finally:
        await bot.session.close()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\n👋 Bot stopped by user")
    except Exception as e:
        print(f"\n❌ Fatal error: {e}")
        sys.exit(1)
EOF

# ============================================================================
# database/__init__.py
# ============================================================================
cat > $PROJECT_NAME/database/__init__.py <<'EOF'
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from sqlalchemy.orm import DeclarativeBase

from config import DATABASE_URL

# Создание асинхронного движка
engine = create_async_engine(DATABASE_URL, echo=False)

# Создание фабрики сессий
async_session_maker = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False
)


class Base(DeclarativeBase):
    """Базовый класс для моделей"""
    pass


async def init_db():
    """Инициализация базы данных"""
    from database.models import User, Export, HostCache
    
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)


async def get_session() -> AsyncSession:
    """Получение сессии базы данных"""
    async with async_session_maker() as session:
        yield session
EOF

# ============================================================================
# database/models.py
# ============================================================================
cat > $PROJECT_NAME/database/models.py <<'EOF'
from datetime import datetime
from typing import Optional

from sqlalchemy import String, Integer, BigInteger, DateTime, Boolean, Text, JSON
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class User(Base):
    """Модель пользователя"""
    __tablename__ = "users"
    
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    username: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    full_name: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    last_activity: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    
    # Статистика
    total_exports: Mapped[int] = mapped_column(Integer, default=0)
    total_requests: Mapped[int] = mapped_column(Integer, default=0)
    
    def __repr__(self):
        return f"<User(id={self.id}, username={self.username})>"


class Export(Base):
    """Модель экспорта данных"""
    __tablename__ = "exports"
    
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(BigInteger, nullable=False)
    host_id: Mapped[str] = mapped_column(String(255), nullable=False)
    host_url: Mapped[str] = mapped_column(String(500), nullable=False)
    
    export_type: Mapped[str] = mapped_column(String(50), nullable=False)
    export_format: Mapped[str] = mapped_column(String(10), default="csv")
    
    # Параметры экспорта
    device_type: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    date_from: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    date_to: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    
    # Результаты
    status: Mapped[str] = mapped_column(String(20), default="pending")  # pending, processing, completed, failed
    rows_exported: Mapped[int] = mapped_column(Integer, default=0)
    file_path: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    file_size: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)  # в байтах
    
    # Время
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    completed_at: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    
    # Ошибки
    error_message: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    
    def __repr__(self):
        return f"<Export(id={self.id}, type={self.export_type}, status={self.status})>"


class HostCache(Base):
    """Кэш информации о хостах"""
    __tablename__ = "host_cache"
    
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(BigInteger, nullable=False)
    host_id: Mapped[str] = mapped_column(String(255), nullable=False)
    
    # Кэшированные данные
    host_data: Mapped[dict] = mapped_column(JSON, nullable=False)
    summary_data: Mapped[Optional[dict]] = mapped_column(JSON, nullable=True)
    
    # Время
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    expires_at: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    
    def __repr__(self):
        return f"<HostCache(host_id={self.host_id}, user_id={self.user_id})>"
EOF

# ============================================================================
# keyboards/__init__.py
# ============================================================================
cat > $PROJECT_NAME/keyboards/__init__.py <<'EOF'
"""Модуль клавиатур для бота"""
from keyboards.menu import (
    get_main_menu,
    get_hosts_keyboard,
    get_host_actions_keyboard,
    get_export_types_keyboard,
    get_device_types_keyboard,
    get_export_formats_keyboard,
    get_back_button
)

__all__ = [
    'get_main_menu',
    'get_hosts_keyboard',
    'get_host_actions_keyboard',
    'get_export_types_keyboard',
    'get_device_types_keyboard',
    'get_export_formats_keyboard',
    'get_back_button'
]
EOF

# ============================================================================
# keyboards/menu.py
# ============================================================================
cat > $PROJECT_NAME/keyboards/menu.py <<'EOF'

from aiogram.types import ReplyKeyboardMarkup, KeyboardButton, InlineKeyboardMarkup, InlineKeyboardButton
from aiogram.utils.keyboard import ReplyKeyboardBuilder, InlineKeyboardBuilder

from config import DEVICE_TYPES, EXPORT_TYPES, EXPORT_FORMATS


def get_main_menu() -> ReplyKeyboardMarkup:
    """Главное меню бота"""
    builder = ReplyKeyboardBuilder()
    
    builder.row(
        KeyboardButton(text="🌐 Мои сайты"),
        KeyboardButton(text="📊 Статистика")
    )
    builder.row(
        KeyboardButton(text="🔐 Авторизация"),
        KeyboardButton(text="ℹ️ Помощь")
    )
    
    return builder.as_markup(resize_keyboard=True)


def get_hosts_keyboard(hosts: list, page: int = 0, page_size: int = 10) -> InlineKeyboardMarkup:
    """Клавиатура со списком хостов"""
    builder = InlineKeyboardBuilder()
    
    # Пагинация
    start_idx = page * page_size
    end_idx = start_idx + page_size
    page_hosts = hosts[start_idx:end_idx]
    
    # Кнопки хостов - используем индекс вместо host_id
    for idx, host in enumerate(page_hosts, start=start_idx):
        # Проверка типа host (объект или словарь)
        if hasattr(host, 'unicode_host_url'):
            host_url = host.unicode_host_url or host.host_url
        else:
            host_url = host.get("unicode_host_url") or host.get("host_url", "Unknown")
        
        # Ограничиваем длину URL для кнопки
        display_url = host_url if len(host_url) <= 40 else host_url[:37] + "..."
        
        builder.button(
            text=f"🌐 {display_url}",
            callback_data=f"host_idx:{idx}"  # Используем индекс
        )
    
    builder.adjust(1)
    
    # Навигация
    nav_buttons = []
    
    if page > 0:
        nav_buttons.append(InlineKeyboardButton(
            text="◀️ Назад",
            callback_data=f"hosts_page:{page-1}"
        ))
    
    if end_idx < len(hosts):
        nav_buttons.append(InlineKeyboardButton(
            text="Вперед ▶️",
            callback_data=f"hosts_page:{page+1}"
        ))
    
    if nav_buttons:
        builder.row(*nav_buttons)
    
    # Кнопка обновления
    builder.row(InlineKeyboardButton(
        text="🔄 Обновить список",
        callback_data="refresh_hosts"
    ))
    
    return builder.as_markup()


def get_host_actions_keyboard() -> InlineKeyboardMarkup:
    """Клавиатура действий для выбранного хоста (host_id берется из state)"""
    builder = InlineKeyboardBuilder()
    
    builder.button(
        text="📊 Создать экспорт",
        callback_data="export_start"
    )
    builder.button(
        text="📈 Статистика сайта",
        callback_data="host_stats"
    )
    builder.button(
        text="🔄 Обновить информацию",
        callback_data="refresh_host"
    )
    builder.button(
        text="🔙 К списку сайтов",
        callback_data="back_to_hosts"
    )
    
    builder.adjust(1)
    return builder.as_markup()


def get_export_types_keyboard() -> InlineKeyboardMarkup:
    """Клавиатура выбора типа экспорта"""
    builder = InlineKeyboardBuilder()
    
    for export_key, export_name in EXPORT_TYPES.items():
        builder.button(
            text=export_name,
            callback_data=f"export_type:{export_key}"
        )
    
    builder.button(
        text="🔙 Назад",
        callback_data="back_to_host_info"
    )
    
    builder.adjust(1)
    return builder.as_markup()


def get_device_types_keyboard() -> InlineKeyboardMarkup:
    """Клавиатура выбора типа устройства"""
    builder = InlineKeyboardBuilder()
    
    device_names = {
        "ALL": "📱 Все устройства",
        "DESKTOP": "💻 Десктоп",
        "MOBILE": "📱 Мобильные",
        "TABLET": "📲 Планшеты"
    }
    
    for device in DEVICE_TYPES:
        builder.button(
            text=device_names.get(device, device),
            callback_data=f"export_device:{device}"
        )
    
    builder.button(
        text="🔙 Назад",
        callback_data="back_to_export_type"
    )
    
    builder.adjust(2)
    return builder.as_markup()


def get_export_formats_keyboard() -> InlineKeyboardMarkup:
    """Клавиатура выбора формата экспорта"""
    builder = InlineKeyboardBuilder()
    
    format_names = {
        "csv": "📄 CSV",
        "xlsx": "📊 Excel (XLSX)",
        "json": "📋 JSON"
    }
    
    for fmt in EXPORT_FORMATS:
        builder.button(
            text=format_names.get(fmt, fmt.upper()),
            callback_data=f"export_format:{fmt}"
        )
    
    builder.button(
        text="🔙 Назад",
        callback_data="back_to_device_select"
    )
    
    builder.adjust(3)
    return builder.as_markup()


def get_back_button(callback_data: str = "back") -> InlineKeyboardMarkup:
    """Универсальная кнопка "Назад" """
    builder = InlineKeyboardBuilder()
    builder.button(text="🔙 Назад", callback_data=callback_data)
    return builder.as_markup()


def get_cancel_keyboard() -> InlineKeyboardMarkup:
    """Клавиатура с кнопкой отмены"""
    builder = InlineKeyboardBuilder()
    builder.button(text="❌ Отменить", callback_data="cancel")
    return builder.as_markup()

EOF

# ============================================================================
# states/export.py
# ============================================================================
cat > $PROJECT_NAME/states/export.py <<'EOF'
from aiogram.fsm.state import State, StatesGroup


class ExportStates(StatesGroup):
    """Состояния для процесса экспорта"""
    
    # Выбор хоста
    selecting_host = State()
    
    # Выбор типа экспорта
    selecting_export_type = State()
    
    # Выбор устройства
    selecting_device = State()
    
    # Выбор формата
    selecting_format = State()
    
    # Настройка дат
    setting_date_from = State()
    setting_date_to = State()
    
    # Процесс экспорта
    exporting = State()
    
    # Завершение
    completed = State()
EOF

# ============================================================================
# utils/__init__.py
# ============================================================================
cat > $PROJECT_NAME/utils/__init__.py <<'EOF'
"""Модуль утилит"""
from utils.logger import setup_logger, log_exception
from utils.helpers import (
    format_number,
    format_percentage,
    format_date,
    truncate_text,
    get_file_size_str,
    validate_date_range
)

__all__ = [
    'setup_logger',
    'log_exception',
    'format_number',
    'format_percentage',
    'format_date',
    'truncate_text',
    'get_file_size_str',
    'validate_date_range'
]
EOF

# ============================================================================
# utils/logger.py
# ============================================================================
cat > $PROJECT_NAME/utils/logger.py <<'EOF'
import logging
import sys
import traceback
from pathlib import Path
from datetime import datetime
from logging.handlers import RotatingFileHandler
import colorlog

from config import LOG_LEVEL, LOG_TO_FILE, LOG_TO_CONSOLE, LOGS_DIR


def setup_logger(name: str = __name__) -> logging.Logger:
    """
    Настройка логгера с цветным выводом и ротацией файлов
    """
    logger = logging.getLogger(name)
    
    # Избегаем дублирования handlers
    if logger.handlers:
        return logger
    
    # Установка уровня
    level = getattr(logging, LOG_LEVEL.upper(), logging.INFO)
    logger.setLevel(level)
    
    # ========================================================================
    # Console Handler с цветами
    # ========================================================================
    if LOG_TO_CONSOLE:
        console_handler = colorlog.StreamHandler(sys.stdout)
        console_handler.setLevel(level)
        
        console_formatter = colorlog.ColoredFormatter(
            '%(log_color)s%(asctime)s - %(name)s - %(levelname)s%(reset)s - %(message)s',
            datefmt='%H:%M:%S',
            log_colors={
                'DEBUG': 'cyan',
                'INFO': 'green',
                'WARNING': 'yellow',
                'ERROR': 'red',
                'CRITICAL': 'red,bg_white',
            }
        )
        console_handler.setFormatter(console_formatter)
        logger.addHandler(console_handler)
    
    # ========================================================================
    # File Handler с ротацией
    # ========================================================================
    if LOG_TO_FILE:
        log_file = Path(LOGS_DIR) / f"bot_{datetime.now().strftime('%Y%m%d')}.log"
        
        file_handler = RotatingFileHandler(
            log_file,
            maxBytes=10 * 1024 * 1024,  # 10 MB
            backupCount=5,
            encoding='utf-8'
        )
        file_handler.setLevel(level)
        
        file_formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )
        file_handler.setFormatter(file_formatter)
        logger.addHandler(file_handler)
    
    return logger


def log_exception(logger: logging.Logger, exception: Exception, context: str = ""):
    """
    Детальное логирование исключения
    """
    error_type = type(exception).__name__
    error_msg = str(exception)
    error_trace = ''.join(traceback.format_exception(type(exception), exception, exception.__traceback__))
    
    logger.error(f"{'='*60}")
    if context:
        logger.error(f"Context: {context}")
    logger.error(f"Exception Type: {error_type}")
    logger.error(f"Exception Message: {error_msg}")
    logger.error(f"Traceback:\n{error_trace}")
    logger.error(f"{'='*60}")
EOF

# ============================================================================
# utils/helpers.py
# ============================================================================
cat > $PROJECT_NAME/utils/helpers.py <<'EOF'
from datetime import datetime, timedelta
from typing import Optional


def format_number(number: int | float) -> str:
    """Форматирование числа с разделителями"""
    return f"{number:,.0f}".replace(",", " ")


def format_percentage(value: float, decimals: int = 2) -> str:
    """Форматирование процента"""
    return f"{value:.{decimals}f}%"


def format_date(date_str: str, input_format: str = "%Y-%m-%d", output_format: str = "%d.%m.%Y") -> str:
    """Форматирование даты"""
    try:
        date_obj = datetime.strptime(date_str, input_format)
        return date_obj.strftime(output_format)
    except Exception:
        return date_str


def truncate_text(text: str, max_length: int = 100, suffix: str = "...") -> str:
    """Обрезка текста с добавлением суффикса"""
    if len(text) <= max_length:
        return text
    return text[:max_length - len(suffix)] + suffix


def get_file_size_str(size_bytes: int) -> str:
    """Преобразование размера файла в человекочитаемый формат"""
    for unit in ['B', 'KB', 'MB', 'GB']:
        if size_bytes < 1024.0:
            return f"{size_bytes:.2f} {unit}"
        size_bytes /= 1024.0
    return f"{size_bytes:.2f} TB"


def validate_date_range(date_from: str, date_to: str, date_format: str = "%Y-%m-%d") -> tuple[bool, str]:
    """
    Валидация диапазона дат
    Возвращает (valid: bool, error_message: str)
    """
    try:
        from_date = datetime.strptime(date_from, date_format)
        to_date = datetime.strptime(date_to, date_format)
        
        # Проверка порядка дат
        if from_date > to_date:
            return False, "Дата начала не может быть позже даты окончания"
        
        # Проверка, что даты не в будущем
        now = datetime.now()
        if from_date > now or to_date > now:
            return False, "Даты не могут быть в будущем"
        
        # Проверка максимального диапазона (например, 1 год)
        max_range = timedelta(days=365)
        if to_date - from_date > max_range:
            return False, f"Максимальный диапазон дат: {max_range.days} дней"
        
        return True, ""
        
    except ValueError as e:
        return False, f"Неверный формат даты: {str(e)}"


def get_date_range_presets() -> dict:
    """Получение предустановленных диапазонов дат"""
    today = datetime.now().date()
    
    return {
        "today": {
            "name": "Сегодня",
            "from": today.isoformat(),
            "to": today.isoformat()
        },
        "yesterday": {
            "name": "Вчера",
            "from": (today - timedelta(days=1)).isoformat(),
            "to": (today - timedelta(days=1)).isoformat()
        },
        "last_7_days": {
            "name": "Последние 7 дней",
            "from": (today - timedelta(days=7)).isoformat(),
            "to": today.isoformat()
        },
        "last_30_days": {
            "name": "Последние 30 дней",
            "from": (today - timedelta(days=30)).isoformat(),
            "to": today.isoformat()
        },
        "current_month": {
            "name": "Текущий месяц",
            "from": today.replace(day=1).isoformat(),
            "to": today.isoformat()
        },
        "last_month": {
            "name": "Прошлый месяц",
            "from": (today.replace(day=1) - timedelta(days=1)).replace(day=1).isoformat(),
            "to": (today.replace(day=1) - timedelta(days=1)).isoformat()
        }
    }


def escape_html(text: str) -> str:
    """Экранирование HTML символов"""
    return (text
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace('"', "&quot;")
            .replace("'", "&#x27;"))


def create_progress_bar(current: int, total: int, length: int = 20) -> str:
    """Создание текстового прогресс-бара"""
    filled = int(length * current / total) if total > 0 else 0
    bar = "█" * filled + "░" * (length - filled)
    percentage = (current / total * 100) if total > 0 else 0
    return f"{bar} {percentage:.1f}%"
EOF

echo "✅ Утилиты созданы"

# ============================================================================
# Продолжение следует в следующей части...
# ============================================================================


echo ""
echo "✅ Скрипт setup_webmaster_bot_v3_complete.sh создан (часть 1)"
echo "📝 Создаю остальные файлы..."

# ============================================================================
# handlers/__init__.py
# ============================================================================
cat > $PROJECT_NAME/handlers/__init__.py <<'EOF'
"""Модуль обработчиков команд"""
EOF

# ============================================================================
# handlers/start.py
# ============================================================================
cat > $PROJECT_NAME/handlers/start.py <<'EOF'
from aiogram import Router, F
from aiogram.types import Message
from aiogram.filters import Command, CommandStart
from aiogram.fsm.context import FSMContext

from keyboards.menu import get_main_menu
from utils.logger import setup_logger
from database import async_session_maker
from database.models import User
from sqlalchemy import select
from config import VERSION, BOT_NAME

router = Router()
logger = setup_logger(__name__)


@router.message(CommandStart())
async def cmd_start(message: Message, state: FSMContext):
    """Обработка команды /start"""
    user_id = message.from_user.id
    logger.info(f"👤 User {user_id} started the bot")
    
    # Сохранение или обновление пользователя в БД
    try:
        async with async_session_maker() as session:
            result = await session.execute(
                select(User).where(User.id == user_id)
            )
            user = result.scalar_one_or_none()
            
            if not user:
                user = User(
                    id=user_id,
                    username=message.from_user.username,
                    full_name=message.from_user.full_name
                )
                session.add(user)
                logger.info(f"✅ New user created: {user_id}")
            else:
                user.username = message.from_user.username
                user.full_name = message.from_user.full_name
                user.total_requests += 1
                logger.info(f"✅ User updated: {user_id}")
            
            await session.commit()
    except Exception as e:
        logger.error(f"❌ Error saving user {user_id}: {e}")
    
    # Очистка состояния
    await state.clear()
    
    welcome_text = (
        f"👋 <b>Добро пожаловать в {BOT_NAME} v{VERSION}!</b>\n\n"
        
        "Я помогу вам работать с Yandex Webmaster API:\n\n"
        
        "📊 <b>Возможности:</b>\n"
        "• Просмотр списка ваших сайтов\n"
        "• Экспорт популярных запросов\n"
        "• История поисковых запросов\n"
        "• Детальная аналитика\n"
        "• Экспорт в CSV, Excel, JSON\n\n"
        
        "🚀 <b>Начните работу:</b>\n"
        "Используйте меню ниже или команду /help для справки\n\n"
        
        "💡 <b>Совет:</b> Начните с команды /token для проверки авторизации"
    )
    
    await message.answer(
        welcome_text,
        reply_markup=get_main_menu()
    )


@router.message(Command("help"))
@router.message(F.text == "ℹ️ Помощь")
async def cmd_help(message: Message):
    """Справка по командам"""
    logger.info(f"👤 User {message.from_user.id} requested help")
    
    help_text = (
        "📚 <b>Справка по командам</b>\n\n"
        
        "<b>Основные команды:</b>\n"
        "/start - Начало работы\n"
        "/help - Эта справка\n"
        "/hosts - Список ваших сайтов\n"
        "/auth - Информация об авторизации\n"
        "/token - Проверка OAuth токена\n"
        "/stats - Статистика использования\n"
        "/diagnose - Диагностика системы\n\n"
        
        "<b>Кнопки меню:</b>\n"
        "🌐 Мои сайты - Список сайтов в Webmaster\n"
        "📊 Статистика - Ваша статистика использования\n"
        "🔐 Авторизация - Информация о токене\n"
        "ℹ️ Помощь - Эта справка\n\n"
        
        "<b>Как работать с экспортом:</b>\n"
        "1. Выберите 'Мои сайты'\n"
        "2. Выберите сайт из списка\n"
        "3. Нажмите 'Создать экспорт'\n"
        "4. Выберите тип данных\n"
        "5. Выберите устройства и формат\n"
        "6. Дождитесь завершения и скачайте файл\n\n"
        
        "<b>Типы экспортов:</b>\n"
        "• Популярные запросы - ТОП запросов\n"
        "• История запросов - История с фильтрами\n"
        "• Расширенная история - Детальные данные\n"
        "• Детальная аналитика - Полная аналитика\n"
        "• Расширенный экспорт - Максимум данных\n\n"
        
        "<b>Форматы экспорта:</b>\n"
        "📄 CSV - Простой текстовый формат\n"
        "📊 Excel - Таблица с форматированием\n"
        "📋 JSON - Структурированные данные\n\n"
        
        "💡 <b>Подсказки:</b>\n"
        "• Используйте /diagnose при проблемах\n"
        "• Проверяйте логи в директории logs/\n"
        "• Все экспорты сохраняются в exports/\n\n"
        
        "📞 <b>Поддержка:</b>\n"
        "При ошибках используйте команду /diagnose\n"
        "для получения детальной диагностики"
    )
    
    await message.answer(help_text)
EOF

# ============================================================================
# handlers/hosts.py - УЛУЧШЕННАЯ ВЕРСИЯ
# ============================================================================
cat > $PROJECT_NAME/handlers/hosts.py <<'EOF'

from aiogram import Router, F
from aiogram.types import Message, CallbackQuery
from aiogram.filters import Command
from aiogram.fsm.context import FSMContext

from services.api import YandexWebmasterAPI
from keyboards.menu import get_hosts_keyboard, get_host_actions_keyboard
from utils.logger import setup_logger, log_exception
from utils.helpers import format_number

router = Router()
logger = setup_logger(__name__)


@router.message(Command("hosts"))
@router.message(F.text == "🌐 Мои сайты")
async def show_hosts(message: Message, state: FSMContext):
    """Показать список сайтов пользователя"""
    user_id = message.from_user.id
    logger.info(f"👤 User {user_id} requested hosts list")
    
    loading_msg = await message.answer("🔍 Загружаю список ваших сайтов...")
    
    try:
        api = YandexWebmasterAPI()
        
        logger.info("Fetching hosts from Yandex API...")
        hosts = await api.get_user_hosts()
        
        if not hosts:
            await loading_msg.edit_text(
                "📭 <b>У вас пока нет сайтов в Yandex Webmaster</b>\n\n"
                "Добавьте сайт на https://webmaster.yandex.ru/"
            )
            logger.info(f"✅ No hosts found for user {user_id}")
            return
        
        # Преобразование в словари
        hosts_data = []
        for host in hosts:
            hosts_data.append({
                "host_id": host.host_id,
                "host_url": host.host_url,
                "unicode_host_url": host.unicode_host_url,
                "verification_state": host.verification_state,
                "verified": host.verified
            })
        
        # Сохранение в state
        await state.update_data(hosts=hosts_data)
        
        hosts_text = f"🌐 <b>Ваши сайты ({len(hosts_data)}):</b>\n\n"
        hosts_text += "Выберите сайт для просмотра информации:"
        
        await loading_msg.edit_text(
            hosts_text,
            reply_markup=get_hosts_keyboard(hosts_data)
        )
        
        logger.info(f"✅ {len(hosts_data)} hosts displayed to user {user_id}")
        
    except Exception as e:
        logger.error(f"❌ Error fetching hosts for user {user_id}")
        log_exception(logger, e, "show_hosts")
        
        await loading_msg.edit_text(
            "❌ <b>Ошибка при загрузке списка сайтов</b>\n\n"
            f"<code>{type(e).__name__}: {str(e)[:200]}</code>\n\n"
            "Попробуйте позже или используйте /diagnose для диагностики"
        )


@router.callback_query(F.data.startswith("hosts_page:"))
async def paginate_hosts(callback: CallbackQuery, state: FSMContext):
    """Пагинация списка хостов"""
    await callback.answer()
    
    page = int(callback.data.split(":")[1])
    user_data = await state.get_data()
    hosts = user_data.get("hosts", [])
    
    if not hosts:
        await callback.answer("Список хостов пуст", show_alert=True)
        return
    
    hosts_text = f"🌐 <b>Ваши сайты ({len(hosts)}):</b>\n\n"
    hosts_text += "Выберите сайт для просмотра информации:"
    
    await callback.message.edit_text(
        hosts_text,
        reply_markup=get_hosts_keyboard(hosts, page=page)
    )


@router.callback_query(F.data == "refresh_hosts")
async def refresh_hosts(callback: CallbackQuery, state: FSMContext):
    """Обновление списка хостов"""
    await callback.answer("🔄 Обновляю список...")
    await show_hosts(callback.message, state)


@router.callback_query(F.data.startswith("host_idx:"))
async def show_host_info(callback: CallbackQuery, state: FSMContext):
    """Показать информацию о выбранном хосте"""
    await callback.answer()
    
    # Получаем индекс из callback
    host_idx = int(callback.data.split(":")[1])
    user_id = callback.from_user.id
    
    # Получаем список хостов из state
    user_data = await state.get_data()
    hosts = user_data.get("hosts", [])
    
    if host_idx >= len(hosts):
        await callback.answer("Хост не найден", show_alert=True)
        return
    
    host_data = hosts[host_idx]
    host_id = host_data["host_id"]
    
    logger.info(f"👤 User {user_id} selected host: {host_id}")
    
    await callback.message.edit_text("🔍 Загружаю информацию о сайте...")
    
    try:
        api = YandexWebmasterAPI()
        
        # Получение базовой информации о хосте
        logger.info(f"Fetching host info for {host_id}")
        host = await api.get_host_info(host_id)
        
        if not host:
            await callback.message.edit_text("❌ Хост не найден")
            return
        
        # Сохраняем выбранный host_id в state
        await state.update_data(selected_host_id=host_id)
        
        # Попытка получить сводную информацию
        try:
            logger.info(f"Fetching host summary for {host_id}")
            summary = await api.get_host_summary(host_id)
            
            info_text = (
                f"🌐 <b>{host.unicode_host_url or host.host_url}</b>\n\n"
                f"🆔 Host ID: <code>{host.host_id[:50]}...</code>\n"
                f"✅ Верификация: {host.verification_state or 'N/A'}\n\n"
            )
            
            if summary:
                # Индексация
                if hasattr(summary, 'indexing_indicators') and summary.indexing_indicators:
                    idx = summary.indexing_indicators
                    info_text += "📊 <b>Индексация:</b>\n"
                    if hasattr(idx, 'site_pages'):
                        info_text += f"   Страниц на сайте: {format_number(idx.site_pages)}\n"
                    if hasattr(idx, 'searchable'):
                        info_text += f"   В поиске: {format_number(idx.searchable)}\n"
                    if hasattr(idx, 'excluded'):
                        info_text += f"   Исключено: {format_number(idx.excluded)}\n"
                    info_text += "\n"
                
                # Поисковые запросы
                if hasattr(summary, 'search_query_indicators') and summary.search_query_indicators:
                    sq = summary.search_query_indicators
                    info_text += "🔍 <b>Поисковые запросы:</b>\n"
                    if hasattr(sq, 'total_shows'):
                        info_text += f"   Показов: {format_number(sq.total_shows)}\n"
                    if hasattr(sq, 'total_clicks'):
                        info_text += f"   Кликов: {format_number(sq.total_clicks)}\n"
                    if hasattr(sq, 'ctr'):
                        info_text += f"   CTR: {sq.ctr:.2f}%\n"
                    info_text += "\n"
                
                # Ссылки
                if hasattr(summary, 'links_indicators') and summary.links_indicators:
                    links = summary.links_indicators
                    info_text += "🔗 <b>Ссылки:</b>\n"
                    if hasattr(links, 'total_internal_links'):
                        info_text += f"   Внутренних: {format_number(links.total_internal_links)}\n"
                    if hasattr(links, 'total_external_links'):
                        info_text += f"   Внешних: {format_number(links.total_external_links)}\n"
            
            logger.info("✅ Summary retrieved successfully")
            
        except Exception as e:
            logger.warning(f"Could not fetch summary: {type(e).__name__}: {str(e)}")
            info_text = (
                f"🌐 <b>{host.unicode_host_url or host.host_url}</b>\n\n"
                f"🆔 Host ID: <code>{host.host_id[:50]}...</code>\n"
                f"✅ Статус: {host.verification_state or 'N/A'}\n"
            )
        
        await callback.message.edit_text(
            info_text,
            reply_markup=get_host_actions_keyboard()
        )
        
        logger.info(f"✅ Host info sent to user {user_id}")
        
    except Exception as e:
        logger.error(f"❌ Error showing host info")
        log_exception(logger, e, "show_host_info")
        await callback.message.answer(
            "❌ Ошибка при загрузке информации о сайте\n\n"
            f"<code>{type(e).__name__}: {str(e)[:100]}</code>"
        )


@router.callback_query(F.data == "back_to_hosts")
async def back_to_hosts(callback: CallbackQuery, state: FSMContext):
    """Вернуться к списку сайтов"""
    await callback.answer()
    
    user_data = await state.get_data()
    hosts = user_data.get("hosts")
    
    if hosts:
        hosts_text = f"🌐 <b>Ваши сайты ({len(hosts)}):</b>\n\n"
        hosts_text += "Выберите сайт для просмотра информации:"
        
        await callback.message.edit_text(
            hosts_text,
            reply_markup=get_hosts_keyboard(hosts)
        )
    else:
        await callback.message.delete()
        await show_hosts(callback.message, state)


@router.callback_query(F.data == "refresh_host")
async def refresh_host_info(callback: CallbackQuery, state: FSMContext):
    """Обновление информации о хосте"""
    await callback.answer("🔄 Обновляю информацию...")
    
    user_data = await state.get_data()
    host_id = user_data.get("selected_host_id")
    
    if not host_id:
        await callback.answer("Хост не выбран", show_alert=True)
        return
    
    # Повторный запрос информации
    try:
        api = YandexWebmasterAPI()
        host = await api.get_host_info(host_id)
        
        if not host:
            await callback.message.edit_text("❌ Хост не найден")
            return
        
        # Получение summary
        try:
            summary = await api.get_host_summary(host_id)
            info_text = (
                f"🌐 <b>{host.unicode_host_url or host.host_url}</b>\n\n"
                f"🆔 Host ID: <code>{host.host_id[:50]}...</code>\n"
                f"✅ Верификация: {host.verification_state or 'N/A'}\n\n"
            )
            
            if summary and hasattr(summary, 'indexing_indicators') and summary.indexing_indicators:
                idx = summary.indexing_indicators
                info_text += "📊 <b>Индексация:</b>\n"
                if hasattr(idx, 'site_pages'):
                    info_text += f"   Страниц на сайте: {format_number(idx.site_pages)}\n"
                if hasattr(idx, 'searchable'):
                    info_text += f"   В поиске: {format_number(idx.searchable)}\n"
                if hasattr(idx, 'excluded'):
                    info_text += f"   Исключено: {format_number(idx.excluded)}\n"
        
        except Exception:
            info_text = (
                f"🌐 <b>{host.unicode_host_url or host.host_url}</b>\n\n"
                f"🆔 Host ID: <code>{host.host_id[:50]}...</code>\n"
                f"✅ Статус: {host.verification_state or 'N/A'}\n"
            )
        
        await callback.message.edit_text(
            info_text,
            reply_markup=get_host_actions_keyboard()
        )
        
    except Exception as e:
        logger.error("Error refreshing host info")
        log_exception(logger, e, "refresh_host_info")
        await callback.answer("Ошибка обновления", show_alert=True)


@router.callback_query(F.data == "back_to_host_info")
async def back_to_host_info(callback: CallbackQuery, state: FSMContext):
    """Вернуться к информации о хосте"""
    await callback.answer()
    await refresh_host_info(callback, state)

EOF

# ============================================================================
# handlers/export.py - ОБРАБОТЧИК ЭКСПОРТОВ
# ============================================================================
cat > $PROJECT_NAME/handlers/export.py <<'EOF'

from aiogram import Router, F
from aiogram.types import CallbackQuery, FSInputFile
from aiogram.fsm.context import FSMContext
from datetime import datetime, timedelta

from services.export import ExportService
from services.api import YandexWebmasterAPI
from keyboards.menu import (
    get_export_types_keyboard,
    get_device_types_keyboard,
    get_export_formats_keyboard
)
from utils.logger import setup_logger, log_exception
from utils.helpers import format_number, get_file_size_str, create_progress_bar
from states.export import ExportStates
from database import async_session_maker
from database.models import Export

router = Router()
logger = setup_logger(__name__)


@router.callback_query(F.data == "export_start")
async def start_export(callback: CallbackQuery, state: FSMContext):
    """Начало процесса экспорта"""
    await callback.answer()
    
    # Проверяем, что host_id есть в state
    user_data = await state.get_data()
    host_id = user_data.get("selected_host_id")
    
    if not host_id:
        await callback.answer("Хост не выбран", show_alert=True)
        return
    
    user_id = callback.from_user.id
    logger.info(f"👤 User {user_id} starting export for host {host_id}")
    
    await state.set_state(ExportStates.selecting_export_type)
    
    await callback.message.edit_text(
        "📊 <b>Выберите тип экспорта:</b>\n\n"
        "• Популярные запросы - ТОП поисковых запросов\n"
        "• История запросов - История с фильтрацией\n"
        "• Расширенная история - Детальные данные\n"
        "• Детальная аналитика - Полная аналитика\n"
        "• Расширенный экспорт - Максимум информации",
        reply_markup=get_export_types_keyboard()
    )


@router.callback_query(F.data.startswith("export_type:"))
async def select_export_type(callback: CallbackQuery, state: FSMContext):
    """Выбор типа экспорта"""
    await callback.answer()
    
    export_type = callback.data.split(":", 1)[1]
    
    logger.info(f"User {callback.from_user.id} selected export type: {export_type}")
    
    # Сохранение типа экспорта
    await state.update_data(export_type=export_type)
    await state.set_state(ExportStates.selecting_device)
    
    await callback.message.edit_text(
        "📱 <b>Выберите тип устройства:</b>\n\n"
        "Для каких устройств выгрузить данные?",
        reply_markup=get_device_types_keyboard()
    )


@router.callback_query(F.data.startswith("export_device:"))
async def select_device_type(callback: CallbackQuery, state: FSMContext):
    """Выбор типа устройства"""
    await callback.answer()
    
    device_type = callback.data.split(":", 1)[1]
    
    logger.info(f"User {callback.from_user.id} selected device: {device_type}")
    
    # Сохранение устройства
    await state.update_data(device_type=device_type)
    await state.set_state(ExportStates.selecting_format)
    
    await callback.message.edit_text(
        "📄 <b>Выберите формат экспорта:</b>\n\n"
        "• CSV - для таблиц и анализа\n"
        "• Excel - с форматированием\n"
        "• JSON - для программной обработки",
        reply_markup=get_export_formats_keyboard()
    )


@router.callback_query(F.data.startswith("export_format:"))
async def select_format_and_export(callback: CallbackQuery, state: FSMContext):
    """Выбор формата и запуск экспорта"""
    await callback.answer()
    
    export_format = callback.data.split(":", 1)[1]
    
    # Получаем все данные из state
    user_data = await state.get_data()
    host_id = user_data.get("selected_host_id")
    export_type = user_data.get("export_type")
    device_type = user_data.get("device_type")
    
    if not host_id or not export_type or not device_type:
        await callback.answer("Ошибка: недостаточно данных", show_alert=True)
        return
    
    user_id = callback.from_user.id
    
    logger.info(f"User {user_id} starting export: type={export_type}, device={device_type}, format={export_format}")
    logger.info(f"Host ID: {host_id}")
    
    # Сохранение формата
    await state.update_data(export_format=export_format)
    await state.set_state(ExportStates.exporting)
    
    # Сообщение о начале экспорта
    progress_msg = await callback.message.edit_text(
        "⏳ <b>Начинаю экспорт данных...</b>\n\n"
        "Это может занять некоторое время в зависимости от объема данных."
    )
    
    try:
        # Получение информации о хосте
        api = YandexWebmasterAPI()
        host = await api.get_host_info(host_id)
        host_url = host.unicode_host_url or host.host_url
        
        # Создание записи в БД
        export_record = Export(
            user_id=user_id,
            host_id=host_id,
            host_url=host_url,
            export_type=export_type,
            export_format=export_format,
            device_type=device_type,
            status="processing"
        )
        
        async with async_session_maker() as session:
            session.add(export_record)
            await session.commit()
            await session.refresh(export_record)
            export_id = export_record.id
        
        # Настройка дат (последние 30 дней по умолчанию)
        date_to = datetime.now().date()
        date_from = date_to - timedelta(days=30)
        
        # Создание сервиса экспорта
        export_service = ExportService(api)
        
        # Функция обновления прогресса
        async def update_progress(current: int, total: int, message: str = ""):
            try:
                progress_bar = create_progress_bar(current, total)
                await progress_msg.edit_text(
                    f"⏳ <b>Экспорт данных...</b>\n\n"
                    f"{progress_bar}\n\n"
                    f"Обработано: {format_number(current)} / {format_number(total)}\n"
                    f"{message}"
                )
            except Exception:
                pass
        
        # Выполнение экспорта
        logger.info(f"Executing export {export_id}")
        
        file_path = await export_service.create_export(
            host_id=host_id,
            export_type=export_type,
            device_type=device_type,
            date_from=date_from.isoformat(),
            date_to=date_to.isoformat(),
            export_format=export_format,
            progress_callback=update_progress
        )
        
        # Получение размера файла
        import os
        file_size = os.path.getsize(file_path)
        
        # Подсчет строк (для CSV)
        rows_count = 0
        if export_format == "csv":
            with open(file_path, 'r', encoding='utf-8') as f:
                rows_count = sum(1 for _ in f) - 1
        
        # Обновление записи в БД
        async with async_session_maker() as session:
            result = await session.get(Export, export_id)
            if result:
                result.status = "completed"
                result.file_path = file_path
                result.file_size = file_size
                result.rows_exported = rows_count
                result.completed_at = datetime.utcnow()
                await session.commit()
        
        # Обновление статистики пользователя
        from database.models import User
        from sqlalchemy import update
        async with async_session_maker() as session:
            await session.execute(
                update(User)
                .where(User.id == user_id)
                .values(total_exports=User.total_exports + 1)
            )
            await session.commit()
        
        # Отправка файла
        logger.info(f"Sending export file to user {user_id}")
        
        file = FSInputFile(file_path)
        
        success_text = (
            "✅ <b>Экспорт завершен!</b>\n\n"
            f"📊 Тип: {export_type}\n"
            f"📱 Устройства: {device_type}\n"
            f"📄 Формат: {export_format.upper()}\n"
            f"📁 Размер: {get_file_size_str(file_size)}\n"
        )
        
        if rows_count:
            success_text += f"📈 Строк: {format_number(rows_count)}\n"
        
        success_text += f"\n⏱ Период: {date_from.strftime('%d.%m.%Y')} - {date_to.strftime('%d.%m.%Y')}"
        
        await callback.message.answer(success_text)
        
        # Отправка файла
        await callback.message.answer_document(
            file,
            caption=f"📊 Экспорт для {host_url}"
        )
        
        # Удаление сообщения о прогрессе
        await progress_msg.delete()
        
        logger.info(f"✅ Export {export_id} completed successfully")
        
        # Очистка состояния
        await state.clear()
        
    except Exception as e:
        logger.error(f"❌ Export failed for user {user_id}")
        log_exception(logger, e, "export")
        
        # Обновление записи в БД
        try:
            async with async_session_maker() as session:
                result = await session.get(Export, export_id)
                if result:
                    result.status = "failed"
                    result.error_message = str(e)[:500]
                    await session.commit()
        except Exception:
            pass
        
        await callback.message.edit_text(
            "❌ <b>Ошибка при экспорте данных</b>\n\n"
            f"<code>{type(e).__name__}: {str(e)[:300]}</code>\n\n"
            "Попробуйте позже или используйте /diagnose"
        )
        
        await state.clear()


@router.callback_query(F.data == "back_to_export_type")
async def back_to_export_type(callback: CallbackQuery, state: FSMContext):
    """Вернуться к выбору типа экспорта"""
    await callback.answer()
    await state.set_state(ExportStates.selecting_export_type)
    
    await callback.message.edit_text(
        "📊 <b>Выберите тип экспорта:</b>\n\n"
        "• Популярные запросы - ТОП поисковых запросов\n"
        "• История запросов - История с фильтрацией\n"
        "• Расширенная история - Детальные данные\n"
        "• Детальная аналитика - Полная аналитика\n"
        "• Расширенный экспорт - Максимум информации",
        reply_markup=get_export_types_keyboard()
    )


@router.callback_query(F.data == "back_to_device_select")
async def back_to_device_select(callback: CallbackQuery, state: FSMContext):
    """Вернуться к выбору устройств"""
    await callback.answer()
    await state.set_state(ExportStates.selecting_device)
    
    await callback.message.edit_text(
        "📱 <b>Выберите тип устройства:</b>\n\n"
        "Для каких устройств выгрузить данные?",
        reply_markup=get_device_types_keyboard()
    )

EOF

echo "✅ Обработчики созданы (start.py, hosts.py, export.py)"

# Продолжение следует...

# ============================================================================
# handlers/auth.py
# ============================================================================
cat > $PROJECT_NAME/handlers/auth.py <<'EOF'
from aiogram import Router, F
from aiogram.types import Message
from aiogram.filters import Command

from services.api import YandexWebmasterAPI, AuthenticationError
from utils.logger import setup_logger, log_exception
from config import YANDEX_ACCESS_TOKEN, API_BASE_URL

router = Router()
logger = setup_logger(__name__)


@router.message(Command("auth"))
@router.message(F.text == "🔐 Авторизация")
async def show_auth_info(message: Message):
    """Информация об авторизации"""
    logger.info(f"👤 User {message.from_user.id} requested auth info")
    
    auth_text = (
        "🔐 <b>Авторизация в Yandex Webmaster</b>\n\n"
        
        "Для работы бота необходим OAuth токен от Яндекса.\n\n"
        
        "<b>📝 Как получить токен:</b>\n"
        "1. Перейдите на https://oauth.yandex.ru/\n"
        "2. Нажмите 'Зарегистрировать приложение'\n"
        "3. Выберите платформу 'Веб-сервисы'\n"
        "4. В разделе 'Доступы' включите:\n"
        "   <code>webmaster:read</code>\n"
        "5. Получите OAuth токен\n"
        "6. Добавьте токен в файл .env:\n"
        "   <code>YANDEX_ACCESS_TOKEN=ваш_токен</code>\n"
        "7. Перезапустите бота\n\n"
        
        "<b>⚠️ Важно:</b>\n"
        "• Токен настраивается администратором\n"
        "• Все пользователи используют один токен\n"
        "• Токен дает доступ только к чтению данных\n\n"
        
        "<b>🔍 Проверка:</b>\n"
        "Используйте команду /token для проверки токена\n\n"
        
        "📚 <b>Документация:</b>\n"
        "https://yandex.ru/dev/webmaster/doc/ru/tasks/how-to-get-oauth"
    )
    
    await message.answer(auth_text)


@router.message(Command("token"))
async def check_token(message: Message):
    """Проверка токена с детальной диагностикой"""
    logger.info(f"👤 User {message.from_user.id} checking token")
    
    check_msg = await message.answer("🔍 Проверка OAuth токена...")
    
    try:
        api = YandexWebmasterAPI()
        
        logger.info("Testing API connection...")
        is_valid = await api.test_connection()
        
        if is_valid:
            user_info = await api.get_user_info()
            
            response_text = (
                "✅ <b>Токен действителен!</b>\n\n"
                f"<b>User ID:</b> <code>{user_info.get('user_id')}</code>\n"
            )
            
            if user_info.get('email'):
                response_text += f"<b>Email:</b> {user_info.get('email')}\n"
            
            response_text += "\n✅ Вы можете использовать все функции бота"
            
            logger.info(f"✅ Token valid for user {message.from_user.id}")
            await check_msg.edit_text(response_text)
        else:
            raise Exception("Token validation failed")
            
    except AuthenticationError as e:
        logger.error(f"❌ Authentication failed for user {message.from_user.id}")
        logger.error(f"   {str(e)}")
        
        await check_msg.edit_text(
            "❌ <b>Токен недействителен!</b>\n\n"
            "<b>Ошибка аутентификации</b>\n\n"
            "<b>Что делать:</b>\n"
            "1. Проверьте YANDEX_ACCESS_TOKEN в .env\n"
            "2. Убедитесь, что токен не истек\n"
            "3. Проверьте права токена (webmaster:read)\n"
            "4. Получите новый токен: /auth\n"
            "5. Перезапустите бота после изменения .env\n\n"
            "💡 Свяжитесь с администратором бота"
        )
        
    except Exception as e:
        logger.error(f"❌ Token check failed for user {message.from_user.id}")
        log_exception(logger, e, "check_token")
        
        await check_msg.edit_text(
            "❌ <b>Ошибка проверки токена!</b>\n\n"
            f"<b>Тип ошибки:</b> {type(e).__name__}\n"
            f"<b>Сообщение:</b>\n<code>{str(e)[:200]}</code>\n\n"
            "<b>Возможные причины:</b>\n"
            "• Проблемы с сетью\n"
            "• API Яндекса недоступен\n"
            "• Неверный формат токена\n\n"
            "Попробуйте позже или используйте /diagnose"
        )


@router.message(Command("diagnose"))
async def diagnose_system(message: Message):
    """Полная диагностика системы"""
    logger.info(f"👤 User {message.from_user.id} requested system diagnostics")
    
    diag_msg = await message.answer("🔍 Запуск диагностики системы...")
    
    results = []
    
    # 1. Проверка конфигурации
    try:
        results.append("✅ Конфигурация загружена")
        results.append(f"   API URL: {API_BASE_URL}")
        results.append(f"   Token length: {len(YANDEX_ACCESS_TOKEN)} chars")
    except Exception as e:
        results.append(f"❌ Ошибка конфигурации: {e}")
    
    # 2. Проверка базы данных
    try:
        from database import async_session_maker
        async with async_session_maker() as session:
            from database.models import User
            from sqlalchemy import select
            result = await session.execute(select(User).limit(1))
            results.append("✅ База данных доступна")
    except Exception as e:
        results.append(f"❌ Ошибка БД: {type(e).__name__}")
    
    # 3. Проверка API
    try:
        api = YandexWebmasterAPI()
        is_valid = await api.test_connection()
        if is_valid:
            results.append("✅ Подключение к Yandex API")
        else:
            results.append("❌ API недоступен")
    except Exception as e:
        results.append(f"❌ Ошибка API: {type(e).__name__}")
    
    # 4. Проверка директорий
    try:
        from pathlib import Path
        from config import EXPORTS_DIR, STATES_DIR, LOGS_DIR
        
        for dir_name, dir_path in [
            ("Exports", EXPORTS_DIR),
            ("States", STATES_DIR),
            ("Logs", LOGS_DIR)
        ]:
            if Path(dir_path).exists():
                results.append(f"✅ {dir_name}: {dir_path}")
            else:
                results.append(f"❌ Отсутствует {dir_name}")
    except Exception as e:
        results.append(f"❌ Ошибка проверки директорий")
    
    # Формирование отчета
    report = "<b>🔍 Результаты диагностики:</b>\n\n" + "\n".join(results)
    
    await diag_msg.edit_text(report)
    logger.info(f"✅ Diagnostics completed for user {message.from_user.id}")
EOF

# ============================================================================
# handlers/stats.py
# ============================================================================
cat > $PROJECT_NAME/handlers/stats.py <<'EOF'
from aiogram import Router, F
from aiogram.types import Message
from aiogram.filters import Command
from datetime import datetime, timedelta

from utils.logger import setup_logger
from utils.helpers import format_number
from database import async_session_maker
from database.models import User, Export
from sqlalchemy import select, func

router = Router()
logger = setup_logger(__name__)


@router.message(Command("stats"))
@router.message(F.text == "📊 Статистика")
async def show_stats(message: Message):
    """Показать статистику пользователя"""
    user_id = message.from_user.id
    logger.info(f"👤 User {user_id} requested stats")
    
    stats_msg = await message.answer("📊 Загружаю статистику...")
    
    try:
        async with async_session_maker() as session:
            # Получение пользователя
            user_result = await session.execute(
                select(User).where(User.id == user_id)
            )
            user = user_result.scalar_one_or_none()
            
            if not user:
                await stats_msg.edit_text("❌ Пользователь не найден")
                return
            
            # Статистика экспортов
            exports_result = await session.execute(
                select(Export).where(Export.user_id == user_id)
            )
            exports = exports_result.scalars().all()
            
            # Подсчет статистики
            total_exports = len(exports)
            completed_exports = len([e for e in exports if e.status == "completed"])
            failed_exports = len([e for e in exports if e.status == "failed"])
            
            # Общий размер файлов
            total_size = sum(e.file_size or 0 for e in exports)
            
            # Статистика по типам
            export_types = {}
            for export in exports:
                export_types[export.export_type] = export_types.get(export.export_type, 0) + 1
            
            # Последний экспорт
            last_export = max(exports, key=lambda e: e.created_at) if exports else None
            
            # Формирование текста
            stats_text = (
                f"📊 <b>Ваша статистика</b>\n\n"
                
                f"👤 <b>Пользователь:</b>\n"
                f"   ID: <code>{user.id}</code>\n"
            )
            
            if user.username:
                stats_text += f"   Username: @{user.username}\n"
            
            stats_text += (
                f"   Активен с: {user.created_at.strftime('%d.%m.%Y')}\n"
                f"   Последняя активность: {user.last_activity.strftime('%d.%m.%Y %H:%M')}\n\n"
                
                f"📈 <b>Экспорты:</b>\n"
                f"   Всего: {format_number(total_exports)}\n"
                f"   Успешных: {format_number(completed_exports)}\n"
                f"   Ошибок: {format_number(failed_exports)}\n"
            )
            
            if total_size > 0:
                from utils.helpers import get_file_size_str
                stats_text += f"   Общий размер: {get_file_size_str(total_size)}\n"
            
            if export_types:
                stats_text += "\n📊 <b>По типам:</b>\n"
                for exp_type, count in sorted(export_types.items(), key=lambda x: x[1], reverse=True):
                    stats_text += f"   {exp_type}: {count}\n"
            
            if last_export:
                stats_text += (
                    f"\n🕐 <b>Последний экспорт:</b>\n"
                    f"   {last_export.created_at.strftime('%d.%m.%Y %H:%M')}\n"
                    f"   Тип: {last_export.export_type}\n"
                    f"   Статус: {last_export.status}\n"
                )
            
            await stats_msg.edit_text(stats_text)
            logger.info(f"✅ Stats sent to user {user_id}")
            
    except Exception as e:
        logger.error(f"❌ Error getting stats for user {user_id}: {e}")
        await stats_msg.edit_text(
            "❌ Ошибка при загрузке статистики\n\n"
            f"<code>{type(e).__name__}: {str(e)[:100]}</code>"
        )


@router.message(Command("admin_stats"))
async def show_admin_stats(message: Message):
    """Показать общую статистику (только для админов)"""
    from config import ADMIN_USER_IDS
    
    user_id = message.from_user.id
    
    if user_id not in ADMIN_USER_IDS:
        await message.answer("⛔ У вас нет доступа к этой команде")
        return
    
    logger.info(f"👤 Admin {user_id} requested admin stats")
    
    stats_msg = await message.answer("📊 Загружаю общую статистику...")
    
    try:
        async with async_session_maker() as session:
            # Общее количество пользователей
            total_users = await session.scalar(select(func.count()).select_from(User))
            
            # Активные пользователи (за последние 7 дней)
            week_ago = datetime.utcnow() - timedelta(days=7)
            active_users = await session.scalar(
                select(func.count()).select_from(User)
                .where(User.last_activity >= week_ago)
            )
            
            # Общая статистика экспортов
            total_exports = await session.scalar(select(func.count()).select_from(Export))
            
            completed_exports = await session.scalar(
                select(func.count()).select_from(Export)
                .where(Export.status == "completed")
            )
            
            # Экспорты за сегодня
            today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)
            today_exports = await session.scalar(
                select(func.count()).select_from(Export)
                .where(Export.created_at >= today_start)
            )
            
            stats_text = (
                "📊 <b>Общая статистика бота</b>\n\n"
                
                f"👥 <b>Пользователи:</b>\n"
                f"   Всего: {format_number(total_users)}\n"
                f"   Активных (7 дней): {format_number(active_users)}\n\n"
                
                f"📈 <b>Экспорты:</b>\n"
                f"   Всего: {format_number(total_exports)}\n"
                f"   Успешных: {format_number(completed_exports)}\n"
                f"   Сегодня: {format_number(today_exports)}\n"
            )
            
            await stats_msg.edit_text(stats_text)
            logger.info(f"✅ Admin stats sent to user {user_id}")
            
    except Exception as e:
        logger.error(f"❌ Error getting admin stats: {e}")
        await stats_msg.edit_text(
            "❌ Ошибка при загрузке статистики"
        )
EOF

# ============================================================================
# services/__init__.py
# ============================================================================
cat > $PROJECT_NAME/services/__init__.py <<'EOF'
"""Модуль сервисов"""
from services.api import YandexWebmasterAPI
from services.export import ExportService

__all__ = ['YandexWebmasterAPI', 'ExportService']
EOF

# ============================================================================
# services/api.py - УЛУЧШЕННАЯ ВЕРСИЯ
# ============================================================================
cat > $PROJECT_NAME/services/api.py <<'EOF'

async def get_search_queries_all_indicators(
    self,
    host_id: str,
    date_from: str,
    date_to: str,
    device_type: str = "ALL",
    limit: int = 500,
    offset: int = 0
) -> Dict:
    """
    Получение поисковых запросов со всеми доступными индикаторами
    Использует другой подход к запросу данных
    """
    
    # Список всех возможных индикаторов согласно документации
    query_indicators = [
        "TOTAL_SHOWS",
        "TOTAL_CLICKS", 
        "AVG_SHOW_POSITION",
        "AVG_CLICK_POSITION",
        "CTR"
    ]
    
    params = {
        "date_from": date_from,
        "date_to": date_to,
        "device_type_indicator": device_type,
        "limit": limit,
        "offset": offset,
        "query_indicator": query_indicators  # Явно запрашиваем индикаторы
    }
    
    try:
        # Получаем user_id
        user_data = await self._make_request("GET", "/user")
        user_id = user_data.get("user_id")
        
        # Получаем запросы
        data = await self._make_request(
            "GET",
            f"/user/{user_id}/hosts/{host_id}/search-queries/popular",
            params=params
        )
        
        return data
    
    except Exception as e:
        logger.error(f"Failed to get search queries with all indicators")
        log_exception(logger, e, "get_search_queries_all_indicators")
        raise

EOF

echo "✅ Сервисы созданы (api.py - часть 1)"

# Продолжение следует...

# ============================================================================
# services/export.py - СЕРВИС ЭКСПОРТА
# ============================================================================
cat > $PROJECT_NAME/services/export.py <<'EOF'

import csv
import json
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Callable, Optional
import asyncio

from config import EXPORTS_DIR, MAX_EXPORT_ROWS, DEFAULT_PAGE_SIZE
from services.api import YandexWebmasterAPI
from utils.logger import setup_logger, log_exception

logger = setup_logger(__name__)


class ExportService:
    """Сервис для экспорта данных"""
    
    def __init__(self, api: YandexWebmasterAPI):
        self.api = api
    
    async def create_export(
        self,
        host_id: str,
        export_type: str,
        device_type: str,
        date_from: str,
        date_to: str,
        export_format: str = "csv",
        progress_callback: Optional[Callable] = None
    ) -> str:
        """Создание экспорта"""
        
        logger.info(f"Creating export: type={export_type}, device={device_type}, format={export_format}")
        logger.info(f"Date range: {date_from} to {date_to}")
        
        # Сбор данных
        if export_type == "popular":
            data = await self._export_popular_queries(
                host_id, date_from, date_to, device_type, progress_callback
            )
        elif export_type == "history":
            data = await self._export_history(
                host_id, date_from, date_to, device_type, progress_callback
            )
        elif export_type == "history_all":
            data = await self._export_history_all(
                host_id, date_from, date_to, device_type, progress_callback
            )
        elif export_type == "analytics":
            data = await self._export_analytics(
                host_id, date_from, date_to, device_type, progress_callback
            )
        elif export_type == "enhanced":
            data = await self._export_enhanced(
                host_id, date_from, date_to, device_type, progress_callback
            )
        else:
            raise ValueError(f"Unknown export type: {export_type}")
        
        # Создание файла
        filename = self._generate_filename(host_id, export_type, export_format)
        file_path = Path(EXPORTS_DIR) / filename
        
        if export_format == "csv":
            self._save_as_csv(data, file_path)
        elif export_format == "xlsx":
            self._save_as_xlsx(data, file_path)
        elif export_format == "json":
            self._save_as_json(data, file_path)
        else:
            raise ValueError(f"Unknown export format: {export_format}")
        
        logger.info(f"Export saved: {file_path}")
        return str(file_path)
    
    def _extract_indicators(self, query: Dict) -> Dict:
        """
        Извлечение индикаторов из различных возможных структур ответа API
        """
        result = {}
        
        # Вариант 1: indicators как объект
        if "indicators" in query and isinstance(query["indicators"], dict):
            indicators = query["indicators"]
            logger.debug(f"Found indicators dict: {indicators}")
            
            # Прямые значения
            for key in ["TOTAL_SHOWS", "TOTAL_CLICKS", "AVG_SHOW_POSITION", 
                       "AVG_CLICK_POSITION", "CTR", "DEMAND"]:
                if key in indicators:
                    result[key] = indicators[key]
            
            # Вложенные объекты (если есть)
            for key, value in indicators.items():
                if isinstance(value, dict):
                    for sub_key, sub_value in value.items():
                        result[f"{key}_{sub_key}"] = sub_value
        
        # Вариант 2: indicators как массив
        elif "indicators" in query and isinstance(query["indicators"], list):
            indicators_list = query["indicators"]
            logger.debug(f"Found indicators list with {len(indicators_list)} items")
            
            if indicators_list:
                # Берем последний элемент (самые свежие данные)
                latest = indicators_list[-1]
                if isinstance(latest, dict):
                    for key, value in latest.items():
                        if key != "date":
                            result[key] = value
        
        # Вариант 3: данные на верхнем уровне
        else:
            logger.debug("No indicators field, checking top level")
            for key in ["TOTAL_SHOWS", "TOTAL_CLICKS", "AVG_SHOW_POSITION",
                       "AVG_CLICK_POSITION", "CTR", "DEMAND",
                       "total_shows", "total_clicks", "avg_show_position",
                       "avg_click_position", "ctr"]:
                if key in query:
                    result[key.upper()] = query[key]
        
        # Логируем что нашли
        if result:
            logger.debug(f"Extracted indicators: {result}")
        else:
            logger.warning(f"No indicators extracted from query: {query.get('query_text', 'unknown')}")
            # Логируем полную структуру для отладки
            logger.debug(f"Full query structure: {json.dumps(query, ensure_ascii=False)[:500]}")
        
        return result
    
    async def _export_popular_queries(
        self,
        host_id: str,
        date_from: str,
        date_to: str,
        device_type: str,
        progress_callback: Optional[Callable] = None
    ) -> List[Dict]:
        """Экспорт популярных запросов с детальной диагностикой"""
        
        all_queries = []
        offset = 0
        page_size = min(DEFAULT_PAGE_SIZE, 500)
        
        logger.info(f"Starting popular queries export for host {host_id}")
        logger.info(f"Parameters: date_from={date_from}, date_to={date_to}, device={device_type}")
        
        while len(all_queries) < MAX_EXPORT_ROWS:
            try:
                logger.info(f"Fetching page at offset {offset}, limit {page_size}")
                
                result = await self.api.get_search_queries(
                    host_id=host_id,
                    date_from=date_from,
                    date_to=date_to,
                    device_type=device_type,
                    limit=page_size,
                    offset=offset,
                    order_by="TOTAL_SHOWS"
                )
                
                # Детальное логирование ответа API
                logger.info(f"API Response keys: {result.keys()}")
                logger.info(f"Total count from API: {result.get('count', 0)}")
                
                queries = result.get("queries", [])
                logger.info(f"Got {len(queries)} queries in this page")
                
                if not queries:
                    logger.info("No more queries, breaking")
                    break
                
                # Логируем структуру первого запроса для отладки
                if queries and offset == 0:
                    first_query = queries[0]
                    logger.info("=" * 60)
                    logger.info("FIRST QUERY STRUCTURE:")
                    logger.info(json.dumps(first_query, ensure_ascii=False, indent=2))
                    logger.info("=" * 60)
                
                # Обработка каждого запроса
                for idx, query in enumerate(queries):
                    row = {
                        "query_id": query.get("query_id", ""),
                        "query_text": query.get("query_text", ""),
                    }
                    
                    # Извлекаем индикаторы
                    indicators = self._extract_indicators(query)
                    
                    if indicators:
                        row.update(indicators)
                    else:
                        # Если индикаторов нет, пробуем альтернативные поля
                        logger.warning(f"No indicators for query: {query.get('query_text')}")
                        
                        # Добавляем пустые поля
                        row.update({
                            "TOTAL_SHOWS": query.get("total_shows", 0),
                            "TOTAL_CLICKS": query.get("total_clicks", 0),
                            "AVG_SHOW_POSITION": query.get("avg_show_position", 0),
                            "AVG_CLICK_POSITION": query.get("avg_click_position", 0),
                            "CTR": query.get("ctr", 0)
                        })
                    
                    all_queries.append(row)
                
                offset += len(queries)
                
                # Обновление прогресса
                if progress_callback:
                    total_found = result.get("count", len(all_queries))
                    await progress_callback(
                        len(all_queries),
                        min(total_found, MAX_EXPORT_ROWS),
                        f"Загружено запросов: {len(all_queries)}"
                    )
                
                # Если получили все данные
                if len(queries) < page_size:
                    logger.info("Received less than page_size, all data fetched")
                    break
                
            except Exception as e:
                logger.error(f"Error fetching popular queries at offset {offset}")
                log_exception(logger, e, "_export_popular_queries")
                break
        
        logger.info(f"✅ Exported {len(all_queries)} popular queries")
        
        # Финальная проверка данных
        non_zero_count = sum(1 for q in all_queries if any(
            q.get(k, 0) != 0 for k in ["TOTAL_SHOWS", "TOTAL_CLICKS"]
        ))
        logger.info(f"Queries with non-zero data: {non_zero_count}/{len(all_queries)}")
        
        return all_queries[:MAX_EXPORT_ROWS]
    
    async def _export_history(
        self,
        host_id: str,
        date_from: str,
        date_to: str,
        device_type: str,
        progress_callback: Optional[Callable] = None
    ) -> List[Dict]:
        """Экспорт истории запросов"""
        
        logger.info("Starting history export...")
        
        # Сначала получаем топ-100 популярных запросов
        result = await self.api.get_search_queries(
            host_id=host_id,
            date_from=date_from,
            date_to=date_to,
            device_type=device_type,
            limit=100,
            offset=0,
            order_by="TOTAL_SHOWS"
        )
        
        top_queries = result.get("queries", [])
        logger.info(f"Got {len(top_queries)} top queries for history")
        
        # Для каждого запроса получаем историю
        history_data = []
        total_queries = len(top_queries)
        
        for idx, query_data in enumerate(top_queries, 1):
            try:
                query_text = query_data.get("query_text")
                query_id = query_data.get("query_id")
                
                if not query_text:
                    continue
                
                logger.debug(f"Fetching history for query: {query_text}")
                
                # Получаем историю для этого запроса
                history = await self.api.get_search_queries_history(
                    host_id=host_id,
                    query_indicator=query_text,
                    date_from=date_from,
                    date_to=date_to,
                    device_type=device_type
                )
                
                # Логируем структуру истории для первого запроса
                if idx == 1:
                    logger.info("=" * 60)
                    logger.info("HISTORY STRUCTURE:")
                    logger.info(json.dumps(history, ensure_ascii=False, indent=2)[:1000])
                    logger.info("=" * 60)
                
                # Обработка точек истории
                indicators_list = history.get("indicators", [])
                logger.debug(f"Got {len(indicators_list)} history points for {query_text}")
                
                for point in indicators_list:
                    row = {
                        "query_id": query_id,
                        "query_text": query_text,
                        "date": point.get("date", ""),
                    }
                    
                    # Извлекаем indicators для каждой даты
                    point_indicators = self._extract_indicators(point)
                    if point_indicators:
                        row.update(point_indicators)
                    
                    history_data.append(row)
                
                # Обновление прогресса
                if progress_callback:
                    await progress_callback(
                        idx,
                        total_queries,
                        f"Обработано запросов: {idx}/{total_queries}"
                    )
                
                # Задержка между запросами
                await asyncio.sleep(0.1)
                
            except Exception as e:
                logger.warning(f"Error fetching history for query '{query_text}': {e}")
                continue
        
        logger.info(f"✅ Exported {len(history_data)} history points")
        return history_data
    
    async def _export_history_all(
        self,
        host_id: str,
        date_from: str,
        date_to: str,
        device_type: str,
        progress_callback: Optional[Callable] = None
    ) -> List[Dict]:
        """Расширенная история запросов"""
        
        # Используем тот же подход что и в history, но с большим количеством запросов
        logger.info("Starting history_all export...")
        
        result = await self.api.get_search_queries(
            host_id=host_id,
            date_from=date_from,
            date_to=date_to,
            device_type=device_type,
            limit=500,
            offset=0,
            order_by="TOTAL_SHOWS"
        )
        
        queries = result.get("queries", [])
        all_history = []
        
        # Ограничиваем до 200 запросов для производительности
        for idx, query_data in enumerate(queries[:200], 1):
            try:
                query_text = query_data.get("query_text")
                query_id = query_data.get("query_id")
                
                if not query_text:
                    continue
                
                history = await self.api.get_search_queries_history(
                    host_id=host_id,
                    query_indicator=query_text,
                    date_from=date_from,
                    date_to=date_to,
                    device_type=device_type
                )
                
                indicators_list = history.get("indicators", [])
                
                for point in indicators_list:
                    row = {
                        "query_id": query_id,
                        "query_text": query_text,
                        "date": point.get("date", ""),
                    }
                    
                    point_indicators = self._extract_indicators(point)
                    if point_indicators:
                        row.update(point_indicators)
                    
                    all_history.append(row)
                
                if progress_callback and idx % 10 == 0:
                    await progress_callback(
                        idx,
                        min(len(queries), 200),
                        f"Обработано: {idx}"
                    )
                
                await asyncio.sleep(0.05)
                
            except Exception as e:
                logger.warning(f"Error in history_all: {e}")
                continue
        
        logger.info(f"✅ Exported {len(all_history)} history_all records")
        return all_history
    
    async def _export_analytics(
        self,
        host_id: str,
        date_from: str,
        date_to: str,
        device_type: str,
        progress_callback: Optional[Callable] = None
    ) -> List[Dict]:
        """Детальная аналитика"""
        
        logger.info("Starting analytics export...")
        
        popular_result = await self.api.get_search_queries(
            host_id=host_id,
            date_from=date_from,
            date_to=date_to,
            device_type=device_type,
            limit=200,
            offset=0,
            order_by="TOTAL_SHOWS"
        )
        
        queries = popular_result.get("queries", [])
        analytics_data = []
        
        for idx, query_data in enumerate(queries, 1):
            try:
                query_text = query_data.get("query_text")
                query_id = query_data.get("query_id")
                
                if not query_text:
                    continue
                
                row = {
                    "query_id": query_id,
                    "query_text": query_text,
                }
                
                # Извлекаем индикаторы
                indicators = self._extract_indicators(query_data)
                if indicators:
                    row.update(indicators)
                
                # Получаем историю для трендов
                try:
                    history = await self.api.get_search_queries_history(
                        host_id=host_id,
                        query_indicator=query_text,
                        date_from=date_from,
                        date_to=date_to,
                        device_type=device_type
                    )
                    
                    indicators_list = history.get("indicators", [])
                    
                    if len(indicators_list) >= 2:
                        row["history_points"] = len(indicators_list)
                        
                        first_point = self._extract_indicators(indicators_list[0])
                        last_point = self._extract_indicators(indicators_list[-1])
                        
                        # Тренд показов
                        first_shows = first_point.get("TOTAL_SHOWS", 0)
                        last_shows = last_point.get("TOTAL_SHOWS", 0)
                        
                        if first_shows > 0:
                            trend = ((last_shows - first_shows) / first_shows) * 100
                            row["shows_trend_percent"] = round(trend, 2)
                        
                        # Тренд кликов
                        first_clicks = first_point.get("TOTAL_CLICKS", 0)
                        last_clicks = last_point.get("TOTAL_CLICKS", 0)
                        
                        if first_clicks > 0:
                            trend = ((last_clicks - first_clicks) / first_clicks) * 100
                            row["clicks_trend_percent"] = round(trend, 2)
                
                except Exception as e:
                    logger.debug(f"Could not get history for analytics: {e}")
                
                analytics_data.append(row)
                
                if progress_callback and idx % 10 == 0:
                    await progress_callback(
                        idx,
                        len(queries),
                        f"Обработано: {idx}/{len(queries)}"
                    )
                
                await asyncio.sleep(0.05)
                
            except Exception as e:
                logger.warning(f"Error in analytics: {e}")
                continue
        
        logger.info(f"✅ Exported {len(analytics_data)} analytics records")
        return analytics_data
    
    async def _export_enhanced(
        self,
        host_id: str,
        date_from: str,
        date_to: str,
        device_type: str,
        progress_callback: Optional[Callable] = None
    ) -> List[Dict]:
        """Расширенный экспорт"""
        
        logger.info("Starting enhanced export...")
        
        # Получаем максимум популярных запросов
        all_queries = []
        offset = 0
        page_size = 500
        
        while len(all_queries) < min(MAX_EXPORT_ROWS, 1000):
            try:
                result = await self.api.get_search_queries(
                    host_id=host_id,
                    date_from=date_from,
                    date_to=date_to,
                    device_type=device_type,
                    limit=page_size,
                    offset=offset,
                    order_by="TOTAL_SHOWS"
                )
                
                queries = result.get("queries", [])
                
                if not queries:
                    break
                
                all_queries.extend(queries)
                offset += len(queries)
                
                if len(queries) < page_size:
                    break
                
            except Exception as e:
                logger.error(f"Error fetching queries at offset {offset}")
                break
        
        logger.info(f"Got {len(all_queries)} queries for enhanced export")
        
        # Обрабатываем каждый запрос
        enhanced_data = []
        
        for idx, query_data in enumerate(all_queries, 1):
            try:
                query_text = query_data.get("query_text")
                query_id = query_data.get("query_id")
                
                if not query_text:
                    continue
                
                row = {
                    "query_id": query_id,
                    "query_text": query_text,
                    "device_type": device_type,
                    "period_from": date_from,
                    "period_to": date_to,
                }
                
                # Извлекаем индикаторы
                indicators = self._extract_indicators(query_data)
                if indicators:
                    row.update(indicators)
                
                enhanced_data.append(row)
                
                if progress_callback and idx % 50 == 0:
                    await progress_callback(
                        idx,
                        len(all_queries),
                        f"Обработано: {idx}/{len(all_queries)}"
                    )
                
            except Exception as e:
                logger.warning(f"Error in enhanced export: {e}")
                continue
        
        logger.info(f"✅ Exported {len(enhanced_data)} enhanced records")
        return enhanced_data
    
    def _generate_filename(self, host_id: str, export_type: str, export_format: str) -> str:
        """Генерация имени файла"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        safe_host_id = host_id.replace(":", "_").replace("/", "_")[:50]
        return f"export_{safe_host_id}_{export_type}_{timestamp}.{export_format}"
    
    def _save_as_csv(self, data: List[Dict], file_path: Path):
        """Сохранение в CSV"""
        
        if not data:
            with open(file_path, 'w', encoding='utf-8-sig', newline='') as f:
                writer = csv.writer(f)
                writer.writerow(["No data available"])
            return
        
        all_keys = set()
        for item in data:
            all_keys.update(item.keys())
        
        priority_keys = ["query_id", "query_text", "date", "device_type", "period_from", "period_to",
                        "TOTAL_SHOWS", "TOTAL_CLICKS", "CTR", "AVG_SHOW_POSITION", "AVG_CLICK_POSITION"]
        fieldnames = [k for k in priority_keys if k in all_keys]
        fieldnames.extend(sorted([k for k in all_keys if k not in priority_keys]))
        
        with open(file_path, 'w', encoding='utf-8-sig', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction='ignore')
            writer.writeheader()
            writer.writerows(data)
        
        logger.info(f"Saved {len(data)} rows to CSV with {len(fieldnames)} columns")
    
    def _save_as_xlsx(self, data: List[Dict], file_path: Path):
        """Сохранение в Excel"""
        
        try:
            import openpyxl
            from openpyxl.styles import Font, Alignment, PatternFill
            
            wb = openpyxl.Workbook()
            ws = wb.active
            ws.title = "Export"
            
            if not data:
                ws['A1'] = "No data available"
                wb.save(file_path)
                return
            
            all_keys = set()
            for item in data:
                all_keys.update(item.keys())
            
            priority_keys = ["query_id", "query_text", "date", "device_type", "period_from", "period_to",
                            "TOTAL_SHOWS", "TOTAL_CLICKS", "CTR", "AVG_SHOW_POSITION", "AVG_CLICK_POSITION"]
            headers = [k for k in priority_keys if k in all_keys]
            headers.extend(sorted([k for k in all_keys if k not in priority_keys]))
            
            # Заголовки
            header_fill = PatternFill(start_color="366092", end_color="366092", fill_type="solid")
            header_font = Font(color="FFFFFF", bold=True)
            
            for col_idx, header in enumerate(headers, 1):
                cell = ws.cell(row=1, column=col_idx, value=header)
                cell.fill = header_fill
                cell.font = header_font
                cell.alignment = Alignment(horizontal="center", vertical="center")
            
            # Данные
            for row_idx, item in enumerate(data, 2):
                for col_idx, key in enumerate(headers, 1):
                    value = item.get(key)
                    cell = ws.cell(row=row_idx, column=col_idx, value=value)
                    
                    if isinstance(value, (int, float)) and not isinstance(value, bool):
                        if key in ["CTR", "ctr", "clicks_trend_percent", "shows_trend_percent"]:
                            cell.number_format = '0.00'
                        elif isinstance(value, float):
                            cell.number_format = '0.00'
                        else:
                            cell.number_format = '#,##0'
            
            # Автоширина
            for column in ws.columns:
                max_length = 0
                column_letter = column[0].column_letter
                for cell in column:
                    if cell.value:
                        max_length = max(max_length, len(str(cell.value)))
                adjusted_width = min(max_length + 2, 50)
                ws.column_dimensions[column_letter].width = adjusted_width
            
            ws.freeze_panes = "A2"
            wb.save(file_path)
            logger.info(f"Saved {len(data)} rows to Excel")
            
        except ImportError:
            logger.warning("openpyxl not available, falling back to CSV")
            self._save_as_csv(data, file_path.with_suffix('.csv'))
    
    def _save_as_json(self, data: List[Dict], file_path: Path):
        """Сохранение в JSON"""
        
        output = {
            "export_date": datetime.now().isoformat(),
            "total_records": len(data),
            "data": data
        }
        
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(output, f, ensure_ascii=False, indent=2)
        
        logger.info(f"Saved {len(data)} items to JSON")

EOF

echo "✅ Сервисы созданы полностью (api.py, export.py)"

# ============================================================================
# start.sh - Скрипт запуска
# ============================================================================
cat > $PROJECT_NAME/start.sh <<'EOF'
#!/bin/bash

echo "🤖 Starting Yandex Webmaster Bot..."

# Проверка виртуального окружения
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found!"
    echo "Please run: python -m venv venv"
    exit 1
fi

# Активация виртуального окружения
source venv/bin/activate

# Проверка .env
if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    echo "Please copy .env.example to .env and configure it"
    exit 1
fi

# Запуск бота
python bot.py
EOF

chmod +x $PROJECT_NAME/start.sh

# ============================================================================
# install.sh - Скрипт установки
# ============================================================================
cat > $PROJECT_NAME/install.sh <<'EOF'
#!/bin/bash

echo "=========================================="
echo "Installing Yandex Webmaster Bot v3.0"
echo "=========================================="

# Проверка Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed"
    exit 1
fi

echo "✅ Python found: $(python3 --version)"

# Создание виртуального окружения
echo "📦 Creating virtual environment..."
python3 -m venv venv

# Активация
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Установка зависимостей
echo "📥 Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# Создание .env если не существует
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "⚠️  Please edit .env file and add your tokens!"
fi

echo ""
echo "=========================================="
echo "✅ Installation completed!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Edit .env file and add your tokens"
echo "2. Run: ./start.sh"
echo ""
EOF

chmod +x $PROJECT_NAME/install.sh

# ============================================================================
# Финализация
# ============================================================================

echo ""
echo "=========================================="
echo "✅ All files created successfully!"
echo "=========================================="
echo ""
echo "Project structure:"
echo ""
echo "$PROJECT_NAME/"
echo "├── bot.py                 # Main bot file"
echo "├── config.py              # Configuration"
echo "├── requirements.txt       # Dependencies"
echo "├── .env.example           # Environment template"
echo "├── .gitignore            # Git ignore rules"
echo "├── README.md             # Documentation"
echo "├── install.sh            # Installation script"
echo "├── start.sh              # Start script"
echo "├── handlers/             # Command handlers"
echo "│   ├── __init__.py"
echo "│   ├── start.py"
echo "│   ├── hosts.py"
echo "│   ├── export.py"
echo "│   ├── auth.py"
echo "│   └── stats.py"
echo "├── services/             # Services"
echo "│   ├── __init__.py"
echo "│   ├── api.py"
echo "│   └── export.py"
echo "├── database/             # Database"
echo "│   ├── __init__.py"
echo "│   └── models.py"
echo "├── keyboards/            # Keyboards"
echo "│   ├── __init__.py"
echo "│   └── menu.py"
echo "├── utils/               # Utilities"
echo "│   ├── __init__.py"
echo "│   ├── logger.py"
echo "│   └── helpers.py"
echo "├── states/              # FSM states"
echo "│   ├── __init__.py"
echo "│   └── export.py"
echo "├── exports/             # Export files directory"
echo "├── logs/                # Logs directory"
echo "└── states/              # States directory"
echo ""
echo "=========================================="
echo "Installation instructions:"
echo "=========================================="
echo ""
echo "1. Go to project directory:"
echo "   cd $PROJECT_NAME"
echo ""
echo "2. Run installation script:"
echo "   chmod +x install.sh"
echo "   ./install.sh"
echo ""
echo "3. Configure .env file:"
echo "   nano .env"
echo "   # Add your TELEGRAM_BOT_TOKEN and YANDEX_ACCESS_TOKEN"
echo ""
echo "4. Start the bot:"
echo "   ./start.sh"
echo ""
echo "=========================================="
echo "📚 Documentation: See README.md"
echo "🐛 Debug: Use /diagnose command in bot"
echo "📊 Logs: Check logs/ directory"
echo "=========================================="
echo ""
echo "✅ Setup complete! Happy coding! 🚀"
echo ""

