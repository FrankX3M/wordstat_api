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
