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
# handlers/auth.py
# ============================================================================
cat > $PROJECT_NAME/handlers/auth.py <<'EOF'

from aiogram import Router, F
from aiogram.types import Message
from aiogram.filters import Command

from services.api import YandexWebmasterAPI
from utils.logger import setup_logger, log_exception
from config import YANDEX_ACCESS_TOKEN, API_BASE_URL

router = Router()
logger = setup_logger(__name__)


@router.message(Command("auth"))
@router.message(F.text == "🔐 Авторизация")
async def show_auth_info(message: Message):
    """Показать информацию об авторизации"""
    user_id = message.from_user.id
    logger.info(f"👤 User {user_id} requested auth info")
    
    auth_msg = await message.answer("🔍 Проверяю авторизацию...")
    
    try:
        api = YandexWebmasterAPI()
        
        # Проверка подключения
        connection_ok = await api.test_connection()
        
        if not connection_ok:
            await auth_msg.edit_text(
                "❌ <b>Ошибка авторизации</b>\n\n"
                "Не удалось подключиться к Yandex Webmaster API\n\n"
                "<b>Возможные причины:</b>\n"
                "• Неверный OAuth токен\n"
                "• Токен истек\n"
                "• Нет прав webmaster:read\n"
                "• Проблемы с сетью\n\n"
                "Используйте /token для детальной проверки"
            )
            return
        
        # Получение информации о пользователе
        try:
            user_info = await api.get_user_info()
            user_id_yandex = user_info.get("user_id", "N/A")
            
            auth_text = (
                "✅ <b>Авторизация успешна!</b>\n\n"
                f"🆔 <b>User ID:</b> <code>{user_id_yandex}</code>\n"
                f"🔗 <b>API:</b> {API_BASE_URL}\n"
                f"🔑 <b>Токен:</b> Активен\n\n"
                "📊 <b>Доступные разрешения:</b>\n"
                "✅ webmaster:read - чтение данных\n\n"
                "💡 <b>Совет:</b>\n"
                "Используйте /hosts для просмотра ваших сайтов"
            )
            
            await auth_msg.edit_text(auth_text)
            logger.info(f"✅ Auth info sent to user {user_id}")
            
        except Exception as e:
            logger.error(f"❌ Error getting user info")
            log_exception(logger, e, "get_user_info")
            
            await auth_msg.edit_text(
                "⚠️ <b>Частичная авторизация</b>\n\n"
                "Подключение к API работает, но не удалось получить данные пользователя.\n\n"
                f"<b>Ошибка:</b>\n<code>{type(e).__name__}: {str(e)[:200]}</code>\n\n"
                "Используйте /diagnose для диагностики"
            )
            
    except Exception as e:
        logger.error(f"❌ Error in auth check for user {user_id}")
        log_exception(logger, e, "show_auth_info")
        
        await auth_msg.edit_text(
            "❌ <b>Ошибка проверки авторизации</b>\n\n"
            f"<code>{type(e).__name__}: {str(e)[:200]}</code>\n\n"
            "Проверьте:\n"
            "1. Правильность токена в .env\n"
            "2. Наличие прав webmaster:read\n"
            "3. Подключение к интернету\n\n"
            "Используйте /diagnose для детальной диагностики"
        )


@router.message(Command("token"))
async def check_token(message: Message):
    """Проверка OAuth токена"""
    user_id = message.from_user.id
    logger.info(f"👤 User {user_id} requested token check")
    
    check_msg = await message.answer("🔍 Проверяю токен...")
    
    try:
        # Базовые проверки токена
        token_length = len(YANDEX_ACCESS_TOKEN)
        token_preview = YANDEX_ACCESS_TOKEN[:10] + "..." + YANDEX_ACCESS_TOKEN[-10:]
        
        check_text = (
            "🔑 <b>Информация о токене</b>\n\n"
            f"📏 <b>Длина:</b> {token_length} символов\n"
            f"👁️ <b>Превью:</b> <code>{token_preview}</code>\n\n"
        )
        
        # Проверка длины
        if token_length < 20:
            check_text += "⚠️ Токен выглядит слишком коротким\n\n"
        else:
            check_text += "✅ Длина токена нормальная\n\n"
        
        # Проверка подключения к API
        check_text += "🔄 Проверяю подключение к API...\n"
        await check_msg.edit_text(check_text)
        
        api = YandexWebmasterAPI()
        connection_ok = await api.test_connection()
        
        if connection_ok:
            check_text += "✅ Подключение к API успешно!\n\n"
            
            # Получение информации о пользователе
            try:
                user_info = await api.get_user_info()
                user_id_yandex = user_info.get("user_id", "N/A")
                
                check_text += (
                    f"👤 <b>User ID:</b> <code>{user_id_yandex}</code>\n"
                    "✅ Токен полностью валиден\n\n"
                    "━━━━━━━━━━━━━━━━━━━━\n\n"
                    "💡 <b>Все проверки пройдены!</b>\n"
                    "Можете начинать работу с ботом."
                )
                
            except Exception as e:
                check_text += (
                    f"⚠️ Не удалось получить User ID\n"
                    f"<code>{type(e).__name__}</code>\n\n"
                    "Токен подключается, но могут быть ограничения."
                )
        else:
            check_text += (
                "❌ Подключение к API не удалось\n\n"
                "<b>Возможные причины:</b>\n"
                "• Неверный токен\n"
                "• Токен истек\n"
                "• Нет прав webmaster:read\n\n"
                "📝 <b>Как получить новый токен:</b>\n"
                "1. Перейдите на https://oauth.yandex.ru/\n"
                "2. Создайте приложение\n"
                "3. Запросите права webmaster:read\n"
                "4. Скопируйте токен в .env файл"
            )
        
        await check_msg.edit_text(check_text)
        logger.info(f"✅ Token check completed for user {user_id}")
        
    except Exception as e:
        logger.error(f"❌ Error checking token for user {user_id}")
        log_exception(logger, e, "check_token")
        
        await check_msg.edit_text(
            "❌ <b>Ошибка проверки токена</b>\n\n"
            f"<code>{type(e).__name__}: {str(e)[:200]}</code>"
        )


@router.message(Command("diagnose"))
async def diagnose_system(message: Message):
    """Диагностика системы"""
    user_id = message.from_user.id
    logger.info(f"👤 User {user_id} requested system diagnosis")
    
    diag_msg = await message.answer("🔍 Запускаю диагностику системы...")
    
    diag_text = "🔬 <b>ДИАГНОСТИКА СИСТЕМЫ</b>\n\n"
    
    # 1. Проверка конфигурации
    diag_text += "━━━ 1️⃣ КОНФИГУРАЦИЯ ━━━\n"
    
    try:
        from config import VERSION, BOT_NAME, DATABASE_URL
        diag_text += f"✅ Бот: {BOT_NAME} v{VERSION}\n"
        diag_text += f"✅ База данных: {DATABASE_URL.split(':///')[-1] if ':///' in DATABASE_URL else 'configured'}\n"
        
        token_len = len(YANDEX_ACCESS_TOKEN)
        if token_len >= 20:
            diag_text += f"✅ OAuth токен: {token_len} символов\n"
        else:
            diag_text += f"⚠️ OAuth токен: {token_len} символов (слишком короткий)\n"
        
    except Exception as e:
        diag_text += f"❌ Ошибка конфигурации: {type(e).__name__}\n"
    
    diag_text += "\n"
    await diag_msg.edit_text(diag_text)
    
    # 2. Проверка API подключения
    diag_text += "━━━ 2️⃣ API ПОДКЛЮЧЕНИЕ ━━━\n"
    
    try:
        api = YandexWebmasterAPI()
        diag_text += f"✅ API URL: {API_BASE_URL}\n"
        
        # Тест подключения
        connection_ok = await api.test_connection()
        if connection_ok:
            diag_text += "✅ Подключение к API: OK\n"
            
            # Получение user info
            try:
                user_info = await api.get_user_info()
                user_id_yandex = user_info.get("user_id", "N/A")
                diag_text += f"✅ User ID: {user_id_yandex}\n"
            except Exception as e:
                diag_text += f"⚠️ User info: {type(e).__name__}\n"
        else:
            diag_text += "❌ Подключение к API: FAILED\n"
            
    except Exception as e:
        diag_text += f"❌ API ошибка: {type(e).__name__}\n"
    
    diag_text += "\n"
    await diag_msg.edit_text(diag_text)
    
    # 3. Проверка базы данных
    diag_text += "━━━ 3️⃣ БАЗА ДАННЫХ ━━━\n"
    
    try:
        from database import async_session_maker
        from database.models import User
        from sqlalchemy import select
        
        async with async_session_maker() as session:
            result = await session.execute(select(User).limit(1))
            user = result.scalar_one_or_none()
            diag_text += "✅ База данных: OK\n"
            
            # Подсчет пользователей
            from sqlalchemy import func
            total_users = await session.scalar(select(func.count()).select_from(User))
            diag_text += f"✅ Пользователей: {total_users}\n"
            
    except Exception as e:
        diag_text += f"❌ БД ошибка: {type(e).__name__}\n"
    
    diag_text += "\n"
    await diag_msg.edit_text(diag_text)
    
    # 4. Проверка файловой системы
    diag_text += "━━━ 4️⃣ ФАЙЛОВАЯ СИСТЕМА ━━━\n"
    
    try:
        from config import EXPORTS_DIR, LOGS_DIR, STATES_DIR
        import os
        
        dirs_ok = 0
        dirs_total = 3
        
        if os.path.exists(EXPORTS_DIR):
            diag_text += f"✅ Exports: {EXPORTS_DIR.name}/\n"
            dirs_ok += 1
        else:
            diag_text += f"❌ Exports: не найдена\n"
        
        if os.path.exists(LOGS_DIR):
            diag_text += f"✅ Logs: {LOGS_DIR.name}/\n"
            dirs_ok += 1
        else:
            diag_text += f"❌ Logs: не найдена\n"
        
        if os.path.exists(STATES_DIR):
            diag_text += f"✅ States: {STATES_DIR.name}/\n"
            dirs_ok += 1
        else:
            diag_text += f"❌ States: не найдена\n"
        
    except Exception as e:
        diag_text += f"❌ FS ошибка: {type(e).__name__}\n"
    
    # Итоговый результат
    diag_text += "\n━━━━━━━━━━━━━━━━━━━━\n\n"
    
    # Подсчет проблем
    errors = diag_text.count("❌")
    warnings = diag_text.count("⚠️")
    
    if errors == 0 and warnings == 0:
        diag_text += "✅ <b>Все проверки пройдены!</b>\n"
        diag_text += "Система работает нормально.\n"
    elif errors == 0:
        diag_text += f"⚠️ <b>Найдено предупреждений: {warnings}</b>\n"
        diag_text += "Система работает, но есть замечания.\n"
    else:
        diag_text += f"❌ <b>Найдено ошибок: {errors}</b>\n"
        if warnings > 0:
            diag_text += f"⚠️ <b>Предупреждений: {warnings}</b>\n"
        diag_text += "\nНеобходимо исправить ошибки.\n"
    
    diag_text += "\n💡 Проверьте логи в директории logs/"
    
    await diag_msg.edit_text(diag_text)
    logger.info(f"✅ Diagnosis completed for user {user_id}: {errors} errors, {warnings} warnings")


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
API_TIMEOUT = 120  # ✅ 2 минуты вместо 30 секунд
MAX_RETRIES = int(os.getenv("RETRY_ATTEMPTS", "5"))  # ✅ 5 попыток вместо 3
RETRY_DELAY = int(os.getenv("RETRY_DELAY", "10"))  # ✅ 10 сек вместо 5

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
    get_export_types_keyboard,
    get_device_types_keyboard,
    get_export_formats_keyboard,
    get_continue_keyboard,
    get_back_button,
    get_cancel_keyboard
)

__all__ = [
    'get_main_menu',
    'get_hosts_keyboard',
    'get_export_types_keyboard',
    'get_device_types_keyboard',
    'get_export_formats_keyboard',
    'get_continue_keyboard',
    'get_back_button',
    'get_cancel_keyboard'
]

EOF

# ============================================================================
# keyboards/menu.py
# ============================================================================
cat > $PROJECT_NAME/keyboards/menu.py <<'EOF'

"""
keyboards/menu.py - ИСПРАВЛЕННАЯ ВЕРСИЯ
Добавлена функция get_continue_keyboard
"""

from aiogram.types import ReplyKeyboardMarkup, KeyboardButton, InlineKeyboardMarkup, InlineKeyboardButton
from aiogram.utils.keyboard import ReplyKeyboardBuilder, InlineKeyboardBuilder

from config import DEVICE_TYPES, EXPORT_FORMATS


def get_main_menu() -> ReplyKeyboardMarkup:
    """Главное меню"""
    builder = ReplyKeyboardBuilder()
    
    builder.row(
        KeyboardButton(text="🌐 Мои сайты")
    )
    builder.row(
        KeyboardButton(text="🔐 Авторизация"),
        KeyboardButton(text="ℹ️ Помощь")
    )
    
    return builder.as_markup(resize_keyboard=True)


def get_hosts_keyboard(hosts: list, page: int = 0, page_size: int = 10) -> InlineKeyboardMarkup:
    """Клавиатура со списком хостов"""
    builder = InlineKeyboardBuilder()
    
    start_idx = page * page_size
    end_idx = start_idx + page_size
    page_hosts = hosts[start_idx:end_idx]
    
    for idx, host in enumerate(page_hosts, start=start_idx):
        if hasattr(host, 'unicode_host_url'):
            host_url = host.unicode_host_url or host.host_url
        else:
            host_url = host.get("unicode_host_url") or host.get("host_url", "Unknown")
        
        display_url = host_url if len(host_url) <= 40 else host_url[:37] + "..."
        
        builder.button(
            text=f"🌐 {display_url}",
            callback_data=f"host_idx:{idx}"
        )
    
    builder.adjust(1)
    
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
    
    builder.row(InlineKeyboardButton(
        text="🔄 Обновить список",
        callback_data="refresh_hosts"
    ))
    
    return builder.as_markup()


def get_export_types_keyboard() -> InlineKeyboardMarkup:
    """Клавиатура выбора типа экспорта"""
    builder = InlineKeyboardBuilder()
    
    builder.button(
        text="🔥 Популярные запросы",
        callback_data="export_type:popular"
    )
    
    builder.button(
        text="📈 История запросов",
        callback_data="export_type:history"
    )
    
    builder.button(
        text="📊 Расширенная история",
        callback_data="export_type:history_all"
    )
    
    builder.button(
        text="🔬 Детальная аналитика",
        callback_data="export_type:analytics"
    )
    
    builder.button(
        text="🚀 Расширенный экспорт",
        callback_data="export_type:enhanced"
    )
    
    builder.button(
        text="🔗 Страницы в поиске",
        callback_data="export_type:pages_in_search"
    )
    
    builder.button(
        text="📋 События со страницами",
        callback_data="export_type:page_events"
    )
    
    builder.button(
        text="❓ Что выбрать?",
        callback_data="export_help"
    )
    
    builder.button(
        text="🔙 К информации о сайте",
        callback_data="back_to_host_info"
    )
    
    builder.adjust(1)
    return builder.as_markup()


def get_date_range_keyboard() -> InlineKeyboardMarkup:
    """Клавиатура выбора периода дат"""
    builder = InlineKeyboardBuilder()
    
    builder.button(
        text="📅 Последние 7 дней",
        callback_data="date_range:last_7_days"
    )
    builder.button(
        text="📅 Последние 14 дней",
        callback_data="date_range:last_14_days"
    )
    builder.button(
        text="📅 Последние 30 дней",
        callback_data="date_range:last_30_days"
    )
    builder.button(
        text="📅 Текущий месяц",
        callback_data="date_range:current_month"
    )
    builder.button(
        text="📅 Прошлый месяц",
        callback_data="date_range:last_month"
    )
    builder.button(
        text="✏️ Свой период",
        callback_data="date_range:custom"
    )
    builder.button(
        text="🔙 Назад",
        callback_data="back_to_export_type"
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
        callback_data="back_to_date_select"
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


def get_continue_keyboard() -> InlineKeyboardMarkup:
    """
    ✅ НОВАЯ ФУНКЦИЯ: Клавиатура с кнопкой "Продолжить"
    Используется для экспорта URL после показа информационного сообщения
    """
    builder = InlineKeyboardBuilder()
    
    builder.button(
        text="▶️ Продолжить",
        callback_data="continue_export"
    )
    
    builder.button(
        text="🔙 Назад",
        callback_data="back_to_export_type"
    )
    
    builder.adjust(1)
    return builder.as_markup()


def get_back_button(callback_data: str = "back") -> InlineKeyboardMarkup:
    """Универсальная кнопка 'Назад'"""
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
    
    # НОВОЕ: Выбор периода дат
    selecting_date_range = State()
    
    # НОВОЕ: Ввод дат вручную
    setting_date_from = State()
    setting_date_to = State()
    
    # Выбор устройства
    selecting_device = State()
    
    # Выбор формата
    selecting_format = State()
    
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

"""
ИСПРАВЛЕННЫЙ handlers/hosts.py
Версия 3.3 - Убрано промежуточное меню, сразу переход к выбору экспорта

ИЗМЕНЕНИЯ:
- При клике на сайт сразу показываем типы экспорта
- Убрана функция get_host_actions_keyboard()
- Кнопка "Назад" ведет сразу к списку сайтов
"""

from aiogram import Router, F
from aiogram.types import Message, CallbackQuery
from aiogram.filters import Command
from aiogram.fsm.context import FSMContext
from aiogram.exceptions import TelegramBadRequest

from services.api import YandexWebmasterAPI
from keyboards.menu import get_hosts_keyboard, get_export_types_keyboard
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
        hosts_text += "Выберите сайт для экспорта данных:"
        
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
    hosts_text += "Выберите сайт для экспорта данных:"
    
    try:
        await callback.message.edit_text(
            hosts_text,
            reply_markup=get_hosts_keyboard(hosts, page=page)
        )
    except TelegramBadRequest as e:
        if "message is not modified" in str(e):
            logger.debug("Message content is the same")
        else:
            raise


@router.callback_query(F.data == "refresh_hosts")
async def refresh_hosts(callback: CallbackQuery, state: FSMContext):
    """Обновление списка хостов"""
    await callback.answer("🔄 Обновляю список...")
    await show_hosts(callback.message, state)


@router.callback_query(F.data.startswith("host_idx:"))
async def show_host_export_menu(callback: CallbackQuery, state: FSMContext):
    """
    ✅ ИСПРАВЛЕНО: Сразу показываем меню экспорта
    Убрано промежуточное меню с информацией о сайте
    """
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
    host_url = host_data.get("unicode_host_url") or host_data.get("host_url", "Unknown")
    
    logger.info(f"👤 User {user_id} selected host: {host_id}")
    logger.info(f"   Going directly to export menu")
    
    # Сохраняем выбранный host_id в state
    await state.update_data(selected_host_id=host_id, selected_host_url=host_url)
    
    # ✅ СРАЗУ ПОКАЗЫВАЕМ ТИПЫ ЭКСПОРТА
    await callback.message.edit_text(
        f"🌐 <b>Сайт:</b> {host_url}\n\n"
        "━━━━━━━━━━━━━━━━━━━━\n\n"
        "📊 <b>Выберите тип экспорта данных:</b>\n\n"
        "Каждый тип дает разные данные и уровень детализации.\n\n"
        "💡 <i>Нажмите \"❓ Что выбрать?\" для подробного описания всех типов</i>",
        reply_markup=get_export_types_keyboard()
    )
    
    logger.info(f"✅ Export type selection displayed for user {user_id}")


@router.callback_query(F.data == "back_to_hosts")
async def back_to_hosts(callback: CallbackQuery, state: FSMContext):
    """Вернуться к списку сайтов"""
    await callback.answer()
    
    user_data = await state.get_data()
    hosts = user_data.get("hosts")
    
    if hosts:
        hosts_text = f"🌐 <b>Ваши сайты ({len(hosts)}):</b>\n\n"
        hosts_text += "Выберите сайт для экспорта данных:"
        
        try:
            await callback.message.edit_text(
                hosts_text,
                reply_markup=get_hosts_keyboard(hosts)
            )
        except TelegramBadRequest as e:
            if "message is not modified" in str(e):
                logger.debug("Message already shows hosts list")
            else:
                raise
    else:
        await callback.message.delete()
        await show_hosts(callback.message, state)


@router.callback_query(F.data == "back_to_host_info")
async def back_to_host_info(callback: CallbackQuery, state: FSMContext):
    """
    ✅ ИСПРАВЛЕНО: Возврат к выбору экспорта вместо информации о хосте
    """
    await callback.answer()
    
    user_data = await state.get_data()
    host_url = user_data.get("selected_host_url", "Неизвестный сайт")
    
    await callback.message.edit_text(
        f"🌐 <b>Сайт:</b> {host_url}\n\n"
        "━━━━━━━━━━━━━━━━━━━━\n\n"
        "📊 <b>Выберите тип экспорта данных:</b>\n\n"
        "Каждый тип дает разные данные и уровень детализации.\n\n"
        "💡 <i>Нажмите \"❓ Что выбрать?\" для подробного описания всех типов</i>",
        reply_markup=get_export_types_keyboard()
    )

EOF

# ============================================================================
# handlers/export.py - ОБРАБОТЧИК ЭКСПОРТОВ
# ============================================================================
cat > $PROJECT_NAME/handlers/export.py <<'EOF'

"""
handlers/export.py - ИСПРАВЛЕННАЯ ВЕРСИЯ v3.4
Добавлена полная поддержка экспорта URL с кнопкой "Продолжить"
"""

from aiogram import Router, F
from aiogram.types import CallbackQuery, Message, FSInputFile
from aiogram.fsm.context import FSMContext
from datetime import datetime
from pathlib import Path

from keyboards.menu import (
    get_export_types_keyboard,
    get_date_range_keyboard,
    get_device_types_keyboard,
    get_export_formats_keyboard,
    get_back_button,
    get_continue_keyboard
)
from states.export import ExportStates
from services.export import ExportService
from services.api import YandexWebmasterAPI
from utils.logger import setup_logger, log_exception
from utils.helpers import validate_date_range, get_date_range_presets

router = Router()
logger = setup_logger(__name__)


# ============================================================================
# 1. НАЧАЛО ЭКСПОРТА - СРАЗУ ПОКАЗЫВАЕМ ТИПЫ
# ============================================================================

@router.callback_query(F.data == "export_start")
async def export_start_handler(callback: CallbackQuery, state: FSMContext):
    """
    🚀 Сразу показываем меню выбора типа экспорта
    """
    await callback.answer()
    
    user_id = callback.from_user.id
    logger.info(f"👤 User {user_id} started export - showing type selection")
    
    # Получаем данные о выбранном хосте
    user_data = await state.get_data()
    selected_host_id = user_data.get("selected_host_id")
    
    if not selected_host_id:
        await callback.answer("❌ Хост не выбран", show_alert=True)
        logger.error(f"No host selected for user {user_id}")
        return
    
    logger.info(f"   Host ID: {selected_host_id}")
    
    # Показываем типы экспорта
    await callback.message.edit_text(
        "📊 <b>Выберите тип экспорта данных:</b>\n\n"
        "Каждый тип дает разные данные и уровень детализации.\n\n"
        "💡 <i>Нажмите \"❓ Что выбрать?\" для подробного описания всех типов</i>",
        reply_markup=get_export_types_keyboard()
    )
    
    await state.set_state(ExportStates.selecting_export_type)
    logger.info("✅ Export type selection menu displayed")


# ============================================================================
# 2. ВЫБОР ТИПА ЭКСПОРТА
# ============================================================================

@router.callback_query(F.data.startswith("export_type:"))
async def select_export_type(callback: CallbackQuery, state: FSMContext):
    """Обработка выбора типа экспорта"""
    await callback.answer()
    
    export_type = callback.data.split(":", 1)[1]
    user_id = callback.from_user.id
    
    logger.info(f"👤 User {user_id} selected export type: {export_type}")
    
    # Описания типов экспорта
    export_descriptions = {
        "popular": {
            "name": "🔥 Популярные запросы",
            "desc": "Самый простой и быстрый вариант. Получите список ТОП запросов с показами, кликами, CTR и позициями."
        },
        "history": {
            "name": "📈 История запросов",
            "desc": "Динамика изменений по ТОП-100 запросам. Отследите рост или падение по каждому запросу за период."
        },
        "history_all": {
            "name": "📊 Расширенная история",
            "desc": "Общая статистика по всему сайту. Суммарные показы/клики за каждый день без разбивки по запросам."
        },
        "analytics": {
            "name": "🔬 Детальная аналитика",
            "desc": "ТОП-200 запросов с расчетом трендов в %. Максимум информации для глубокого анализа."
        },
        "enhanced": {
            "name": "🚀 Расширенный экспорт",
            "desc": "До 1,000 запросов с метаданными и временными метками. Идеально для архивирования."
        },
        "urls": {
            "name": "🔗 Экспорт URL страниц",
            "desc": "Связь между запросами и URL страниц. Найдите каннибализацию ключевых слов и нецелевой трафик."
        }
    }
    
    # Сохраняем выбранный тип
    await state.update_data(export_type=export_type)
    
    # ✅ ИСПРАВЛЕНИЕ: Для типа "urls" показываем информацию с кнопкой "Продолжить"
    if export_type == "urls":
        await callback.message.edit_text(
            "🔗 <b>Экспорт URL страниц</b>\n\n"
            "⚠️ <b>Внимание:</b> Этот тип экспорта показывает связь между:\n"
            "• Поисковыми запросами\n"
            "• URL страниц, которые показываются в поиске\n"
            "• Статистикой показов/кликов для каждой связки\n\n"
            "<b>Зачем это нужно?</b>\n"
            "✅ Найти страницы с нецелевым трафиком\n"
            "✅ Обнаружить каннибализацию ключевых слов\n"
            "✅ Оптимизировать структуру сайта\n\n"
            "<b>Пример:</b>\n"
            "<code>\"купить ноутбук\" → /catalog/notebooks (850 показов)\n"
            "\"купить ноутбук\" → /blog/review (120 показов)</code>\n\n"
            "⚠️ Две страницы конкурируют за один запрос!\n\n"
            "Нажмите <b>\"Продолжить\"</b> для настройки параметров экспорта.",
            reply_markup=get_continue_keyboard()
        )
        # НЕ меняем состояние - ждем нажатия "Продолжить"
        return
    
    # Для остальных типов - переходим к выбору периода
    type_info = export_descriptions.get(export_type, {
        "name": export_type.upper(),
        "desc": "Экспорт данных из Yandex Webmaster"
    })
    
    await callback.message.edit_text(
        f"{type_info['name']}\n\n"
        f"<i>{type_info['desc']}</i>\n\n"
        f"━━━━━━━━━━━━━━━━━━━━\n\n"
        f"📅 <b>Выберите период данных:</b>\n\n"
        f"Выберите предустановленный период или укажите свой:",
        reply_markup=get_date_range_keyboard()
    )
    
    await state.set_state(ExportStates.selecting_date_range)
    logger.info(f"✅ Date range selection displayed for {export_type}")


# ✅ НОВЫЙ ОБРАБОТЧИК: Кнопка "Продолжить" для экспорта URL
@router.callback_query(F.data == "continue_export")
async def continue_export_urls(callback: CallbackQuery, state: FSMContext):
    """Продолжить настройку экспорта URL после информационного сообщения"""
    await callback.answer()
    
    user_id = callback.from_user.id
    logger.info(f"👤 User {user_id} confirmed URLs export - showing date selection")
    
    # Переходим к выбору периода дат
    await callback.message.edit_text(
        f"🔗 <b>Экспорт URL страниц</b>\n\n"
        f"━━━━━━━━━━━━━━━━━━━━\n\n"
        f"📅 <b>Выберите период данных:</b>\n\n"
        f"Выберите предустановленный период или укажите свой:",
        reply_markup=get_date_range_keyboard()
    )
    
    await state.set_state(ExportStates.selecting_date_range)
    logger.info("✅ Date range selection displayed for URLs export")


# ============================================================================
# 3. ВЫБОР ПЕРИОДА ДАТ
# ============================================================================

@router.callback_query(F.data.startswith("date_range:"))
async def select_date_range(callback: CallbackQuery, state: FSMContext):
    """Выбор периода дат"""
    await callback.answer()
    
    range_key = callback.data.split(":", 1)[1]
    user_id = callback.from_user.id
    
    logger.info(f"👤 User {user_id} selected date range: {range_key}")
    
    if range_key == "custom":
        await callback.message.edit_text(
            "📅 <b>Укажите дату начала периода</b>\n\n"
            "Формат: <code>YYYY-MM-DD</code>\n"
            "Например: <code>2024-12-01</code>\n\n"
            "💡 Отправьте сообщение с датой:",
            reply_markup=get_back_button("back_to_date_select")
        )
        await state.set_state(ExportStates.setting_date_from)
        return
    
    # Получаем предустановленный период
    presets = get_date_range_presets()
    
    if range_key not in presets:
        logger.error(f"Unknown date range preset: {range_key}")
        await callback.answer("❌ Неизвестный период", show_alert=True)
        return
    
    date_range = presets[range_key]
    date_from = date_range["from"]
    date_to = date_range["to"]
    
    await state.update_data(date_from=date_from, date_to=date_to)
    
    logger.info(f"✅ Date range set: {date_from} to {date_to}")
    
    # Переходим к выбору устройства
    await callback.message.edit_text(
        f"📅 <b>Выбран период:</b>\n"
        f"{date_range['name']}\n"
        f"<code>С {date_from} по {date_to}</code>\n\n"
        f"━━━━━━━━━━━━━━━━━━━━\n\n"
        f"📱 <b>Выберите тип устройства:</b>\n\n"
        f"Для какого типа устройств выгрузить данные?",
        reply_markup=get_device_types_keyboard()
    )
    
    await state.set_state(ExportStates.selecting_device)


# ============================================================================
# 4. ВВОД ДАТ ВРУЧНУЮ
# ============================================================================

@router.message(ExportStates.setting_date_from)
async def process_date_from(message: Message, state: FSMContext):
    """Обработка даты начала"""
    date_from = message.text.strip()
    user_id = message.from_user.id
    
    logger.info(f"👤 User {user_id} entered date_from: {date_from}")
    
    # Валидация формата
    try:
        datetime.strptime(date_from, "%Y-%m-%d")
    except ValueError:
        logger.warning(f"Invalid date format from user {user_id}: {date_from}")
        await message.answer(
            "❌ <b>Неверный формат даты!</b>\n\n"
            "Используйте формат: <code>YYYY-MM-DD</code>\n"
            "Например: <code>2024-12-01</code>\n\n"
            "Попробуйте еще раз:"
        )
        return
    
    # Проверка что дата не в будущем
    if datetime.strptime(date_from, "%Y-%m-%d") > datetime.now():
        await message.answer(
            "❌ Дата не может быть в будущем!\n\n"
            "Попробуйте еще раз:"
        )
        return
    
    await state.update_data(date_from=date_from)
    logger.info(f"✅ date_from saved: {date_from}")
    
    await message.answer(
        f"✅ <b>Дата начала:</b> <code>{date_from}</code>\n\n"
        f"📅 <b>Теперь укажите дату окончания</b>\n\n"
        f"Формат: <code>YYYY-MM-DD</code>\n"
        f"Например: <code>2024-12-19</code>",
        reply_markup=get_back_button("back_to_date_select")
    )
    
    await state.set_state(ExportStates.setting_date_to)


@router.message(ExportStates.setting_date_to)
async def process_date_to(message: Message, state: FSMContext):
    """Обработка даты окончания"""
    date_to = message.text.strip()
    user_id = message.from_user.id
    
    logger.info(f"👤 User {user_id} entered date_to: {date_to}")
    
    # Валидация формата
    try:
        datetime.strptime(date_to, "%Y-%m-%d")
    except ValueError:
        logger.warning(f"Invalid date format from user {user_id}: {date_to}")
        await message.answer(
            "❌ <b>Неверный формат даты!</b>\n\n"
            "Используйте формат: <code>YYYY-MM-DD</code>\n"
            "Попробуйте еще раз:"
        )
        return
    
    # Валидация диапазона
    user_data = await state.get_data()
    date_from = user_data.get("date_from")
    
    is_valid, error_msg = validate_date_range(date_from, date_to)
    
    if not is_valid:
        logger.warning(f"Invalid date range: {error_msg}")
        await message.answer(f"❌ {error_msg}\n\nПопробуйте еще раз:")
        return
    
    await state.update_data(date_to=date_to)
    logger.info(f"✅ date_to saved: {date_to}")
    
    await message.answer(
        f"✅ <b>Период выбран:</b>\n"
        f"<code>С {date_from} по {date_to}</code>\n\n"
        f"━━━━━━━━━━━━━━━━━━━━\n\n"
        f"📱 <b>Выберите тип устройства:</b>",
        reply_markup=get_device_types_keyboard()
    )
    
    await state.set_state(ExportStates.selecting_device)


# ============================================================================
# 5. ВЫБОР ТИПА УСТРОЙСТВА
# ============================================================================

@router.callback_query(F.data.startswith("export_device:"))
async def select_device_type(callback: CallbackQuery, state: FSMContext):
    """Выбор типа устройства"""
    await callback.answer()
    
    device_type = callback.data.split(":", 1)[1]
    user_id = callback.from_user.id
    
    await state.update_data(device_type=device_type)
    
    logger.info(f"👤 User {user_id} selected device: {device_type}")
    
    device_names = {
        "ALL": "📱 Все устройства",
        "DESKTOP": "💻 Десктоп",
        "MOBILE": "📱 Мобильные",
        "TABLET": "📲 Планшеты"
    }
    
    device_display = device_names.get(device_type, device_type)
    
    await callback.message.edit_text(
        f"📱 <b>Выбрано:</b> {device_display}\n\n"
        f"━━━━━━━━━━━━━━━━━━━━\n\n"
        f"📄 <b>Выберите формат экспорта:</b>\n\n"
        f"В каком формате сохранить данные?",
        reply_markup=get_export_formats_keyboard()
    )
    
    await state.set_state(ExportStates.selecting_format)


# ============================================================================
# 6. ВЫБОР ФОРМАТА И ЗАПУСК ЭКСПОРТА
# ============================================================================

@router.callback_query(F.data.startswith("export_format:"))
async def select_export_format(callback: CallbackQuery, state: FSMContext):
    """Выбор формата и запуск экспорта"""
    await callback.answer()
    
    export_format = callback.data.split(":", 1)[1]
    user_id = callback.from_user.id
    
    await state.update_data(export_format=export_format)
    
    logger.info(f"👤 User {user_id} selected format: {export_format}")
    
    # Получаем все параметры экспорта
    user_data = await state.get_data()
    
    export_type = user_data.get("export_type")
    device_type = user_data.get("device_type")
    date_from = user_data.get("date_from")
    date_to = user_data.get("date_to")
    host_id = user_data.get("selected_host_id")
    
    # Проверка наличия всех параметров
    if not all([export_type, device_type, date_from, date_to, host_id]):
        logger.error(f"Missing export parameters for user {user_id}")
        logger.error(f"  export_type: {export_type}")
        logger.error(f"  device_type: {device_type}")
        logger.error(f"  date_from: {date_from}")
        logger.error(f"  date_to: {date_to}")
        logger.error(f"  host_id: {host_id}")
        
        await callback.message.edit_text(
            "❌ <b>Ошибка:</b> Не все параметры заполнены\n\n"
            "Пожалуйста, начните заново с выбора типа экспорта.",
            reply_markup=get_back_button("back_to_host_info")
        )
        return
    
    # Красивое отображение параметров
    format_names = {
        "csv": "📄 CSV",
        "xlsx": "📊 Excel (XLSX)",
        "json": "📋 JSON"
    }
    
    device_names = {
        "ALL": "📱 Все устройства",
        "DESKTOP": "💻 Десктоп",
        "MOBILE": "📱 Мобильные",
        "TABLET": "📲 Планшеты"
    }
    
    type_names = {
        "popular": "🔥 Популярные запросы",
        "history": "📈 История запросов",
        "history_all": "📊 Расширенная история",
        "analytics": "🔬 Детальная аналитика",
        "enhanced": "🚀 Расширенный экспорт",
        "urls": "🔗 Экспорт URL"
    }
    
    confirmation_text = (
        "✅ <b>Параметры экспорта:</b>\n\n"
        f"📊 Тип: {type_names.get(export_type, export_type)}\n"
        f"📅 Период: <code>{date_from} — {date_to}</code>\n"
        f"📱 Устройство: {device_names.get(device_type, device_type)}\n"
        f"📄 Формат: {format_names.get(export_format, export_format.upper())}\n\n"
        f"━━━━━━━━━━━━━━━━━━━━\n\n"
        f"🚀 <b>Начинаю создание экспорта...</b>\n"
        f"⏳ Это может занять некоторое время"
    )
    
    progress_msg = await callback.message.edit_text(confirmation_text)
    
    await state.set_state(ExportStates.exporting)
    
    logger.info("=" * 80)
    logger.info(f"STARTING EXPORT FOR USER {user_id}")
    logger.info(f"  Type: {export_type}")
    logger.info(f"  Device: {device_type}")
    logger.info(f"  Date range: {date_from} to {date_to}")
    logger.info(f"  Format: {export_format}")
    logger.info(f"  Host ID: {host_id}")
    logger.info("=" * 80)
    
    # ЗАПУСК ЭКСПОРТА
    try:
        api = YandexWebmasterAPI()
        export_service = ExportService(api)
        
        # Callback для обновления прогресса
        last_update_time = [datetime.now()]
        
        async def update_progress(current: int, total: int, message: str):
            """Обновление прогресса с throttling"""
            try:
                now = datetime.now()
                if (now - last_update_time[0]).total_seconds() < 2:
                    return
                
                last_update_time[0] = now
                
                percentage = (current / total * 100) if total > 0 else 0
                
                from utils.helpers import create_progress_bar
                progress_bar = create_progress_bar(current, total, length=20)
                
                progress_text = (
                    f"⏳ <b>Экспорт в процессе...</b>\n\n"
                    f"{progress_bar}\n\n"
                    f"📊 {message}\n"
                    f"Прогресс: {current:,} / {total:,} ({percentage:.1f}%)\n\n"
                    f"⚡ Пожалуйста, подождите...\n"
                    f"<i>Не закрывайте чат</i>"
                )
                
                await progress_msg.edit_text(progress_text)
                logger.debug(f"Progress: {current}/{total} ({percentage:.1f}%)")
                
            except Exception as e:
                logger.warning(f"Failed to update progress: {e}")
        
        # Создание экспорта
        logger.info("🔄 Calling export_service.create_export()...")
        
        file_path = await export_service.create_export(
            host_id=host_id,
            export_type=export_type,
            device_type=device_type,
            date_from=date_from,
            date_to=date_to,
            export_format=export_format,
            progress_callback=update_progress
        )
        
        logger.info(f"✅ Export file created: {file_path}")
        
        # Проверка существования файла
        if not Path(file_path).exists():
            raise FileNotFoundError(f"Export file not found: {file_path}")
        
        file_size = Path(file_path).stat().st_size
        logger.info(f"   File size: {file_size:,} bytes")
        
        # Отправка файла пользователю
        logger.info("📤 Sending file to user...")
        
        await callback.message.answer_document(
            document=FSInputFile(file_path),
            caption=(
                f"✅ <b>Экспорт завершен успешно!</b>\n\n"
                f"📊 Тип: {type_names.get(export_type, export_type)}\n"
                f"📅 Период: <code>{date_from} — {date_to}</code>\n"
                f"📱 Устройство: {device_names.get(device_type, device_type)}\n"
                f"📄 Формат: {format_names.get(export_format, export_format.upper())}\n\n"
                f"💾 Размер файла: {file_size:,} байт\n\n"
                f"━━━━━━━━━━━━━━━━━━━━\n\n"
                f"💡 Используйте <b>/hosts</b> для нового экспорта"
            )
        )
        
        await progress_msg.delete()
        await state.set_state(ExportStates.completed)
        
        logger.info(f"✅ Export completed successfully for user {user_id}")
        
    except FileNotFoundError as e:
        logger.error(f"❌ Export file not found: {e}")
        log_exception(logger, e, "export_file_not_found")
        
        await progress_msg.edit_text(
            f"❌ <b>Ошибка: файл экспорта не найден</b>\n\n"
            f"Возможно экспорт не содержит данных.\n\n"
            f"Попробуйте:\n"
            f"• Выбрать другой период\n"
            f"• Изменить тип устройства\n"
            f"• Использовать другой тип экспорта"
        )
        
    except Exception as e:
        logger.error(f"❌ Export failed for user {user_id}")
        log_exception(logger, e, "export_process")
        
        error_type = type(e).__name__
        error_msg = str(e)[:300]
        
        await progress_msg.edit_text(
            f"❌ <b>Ошибка при создании экспорта</b>\n\n"
            f"<b>Тип ошибки:</b> <code>{error_type}</code>\n"
            f"<b>Сообщение:</b>\n<code>{error_msg}</code>\n\n"
            f"━━━━━━━━━━━━━━━━━━━━\n\n"
            f"<b>Что делать:</b>\n"
            f"1. Попробуйте другой период дат\n"
            f"2. Выберите другой тип экспорта\n"
            f"3. Используйте /diagnose для диагностики\n"
            f"4. Проверьте логи в директории logs/\n\n"
            f"💡 Если ошибка повторяется, свяжитесь с администратором"
        )


# ============================================================================
# 7. КНОПКИ НАВИГАЦИИ "НАЗАД"
# ============================================================================

@router.callback_query(F.data == "back_to_export_type")
async def back_to_export_type(callback: CallbackQuery, state: FSMContext):
    """Вернуться к выбору типа экспорта"""
    await callback.answer()
    logger.info(f"User {callback.from_user.id} going back to export type selection")
    await export_start_handler(callback, state)


@router.callback_query(F.data == "back_to_date_select")
async def back_to_date_select(callback: CallbackQuery, state: FSMContext):
    """Вернуться к выбору дат"""
    await callback.answer()
    
    user_data = await state.get_data()
    export_type = user_data.get("export_type")
    
    logger.info(f"User {callback.from_user.id} going back to date selection")
    
    if not export_type:
        logger.warning("No export_type in state, redirecting to export type selection")
        await export_start_handler(callback, state)
        return
    
    await callback.message.edit_text(
        f"📅 <b>Выберите период данных:</b>\n\n"
        f"Выберите предустановленный период или укажите свой:",
        reply_markup=get_date_range_keyboard()
    )
    await state.set_state(ExportStates.selecting_date_range)


@router.callback_query(F.data == "back_to_device_select")
async def back_to_device_select(callback: CallbackQuery, state: FSMContext):
    """Вернуться к выбору устройства"""
    await callback.answer()
    
    logger.info(f"User {callback.from_user.id} going back to device selection")
    
    await callback.message.edit_text(
        f"📱 <b>Выберите тип устройства:</b>\n\n"
        f"Для какого типа устройств выгрузить данные?",
        reply_markup=get_device_types_keyboard()
    )
    await state.set_state(ExportStates.selecting_device)


@router.callback_query(F.data == "export_help")
async def show_export_help(callback: CallbackQuery):
    """Показать подробную справку по типам экспорта"""
    await callback.answer()
    
    help_text = """
📚 <b>ТИПЫ ЭКСПОРТА - Подробное описание</b>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔥 <b>ПОПУЛЯРНЫЕ ЗАПРОСЫ</b>
<i>Самый простой и быстрый вариант</i>

<b>Что получите:</b>
- Список поисковых запросов по убыванию показов
- Показы, клики, CTR
- Средние позиции показа и клика
- До 10,000 запросов за один экспорт

<b>Когда использовать:</b>
✅ Нужен быстрый список ТОП запросов
✅ Хотите понять, по каким запросам вас находят
✅ Анализ общей картины трафика

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📈 <b>ИСТОРИЯ ЗАПРОСОВ</b>
<i>Динамика изменений по ТОП-100 запросам</i>

<b>Что получите:</b>
- ТОП-100 самых популярных запросов
- История показов/кликов по дням
- Можно отследить тренды
- Видно рост или падение по каждому запросу

<b>Когда использовать:</b>
✅ Нужно отследить динамику конкретных запросов
✅ Анализ эффективности SEO работ
✅ Понять, какие запросы растут/падают

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 <b>РАСШИРЕННАЯ ИСТОРИЯ</b>
<i>Общая статистика по ВСЕМ запросам</i>

<b>Что получите:</b>
- Суммарная статистика за каждый день
- TOTAL показов/кликов по всему сайту
- Не разбито по отдельным запросам
- Компактный формат данных

<b>Когда использовать:</b>
✅ Нужна общая динамика трафика сайта
✅ Анализ сезонности
✅ Сравнение периодов (до/после изменений)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔬 <b>ДЕТАЛЬНАЯ АНАЛИТИКА</b>
<i>Максимум информации + тренды</i>

<b>Что получите:</b>
- ТОП-200 запросов
- Все стандартные метрики
- + Расчет трендов в %
- + Количество точек истории

<b>Когда использовать:</b>
✅ Глубокий анализ эффективности
✅ Подготовка отчетов с трендами
✅ Выявление перспективных запросов

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚀 <b>РАСШИРЕННЫЙ ЭКСПОРТ</b>
<i>Максимум запросов с метаданными</i>

<b>Что получите:</b>
- До 1,000 запросов
- Все метрики
- + Временные метки экспорта
- + Параметры устройств и периода

<b>Когда использовать:</b>
✅ Создание архива данных
✅ Сравнение разных периодов/устройств
✅ Экспорт в аналитические системы

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔗 <b>ЭКСПОРТ URL СТРАНИЦ</b>
<i>Какие страницы показываются по запросам</i>

<b>Что получите:</b>
- Связку: ЗАПРОС → URL страницы
- Показы и клики для каждой связки
- Понимание, какая страница ранжируется
- Выявление нецелевых страниц

<b>Когда использовать:</b>
✅ Аудит структуры сайта
✅ Поиск каннибализации ключевых слов
✅ Оптимизация посадочных страниц

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 <b>ЧТО ВЫБРАТЬ?</b>

<b>Для начала:</b> 🔥 Популярные запросы
<b>Для SEO анализа:</b> 📈 История запросов
<b>Для отчетов:</b> 📊 Расширенная история
<b>Для глубокой аналитики:</b> 🔬 Детальная аналитика
<b>Для архивов:</b> 🚀 Расширенный экспорт
<b>Для аудита:</b> 🔗 Экспорт URL

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

<b>Все типы доступны в 3 форматах:</b>
📄 CSV - для Excel/Google Sheets
📊 XLSX - Excel с форматированием
📋 JSON - для программ
"""
    
    await callback.message.edit_text(
        help_text,
        reply_markup=get_back_button("back_to_export_type")
    )


# ============================================================================
# 8. ОТМЕНА ПРОЦЕССА
# ============================================================================

@router.callback_query(F.data == "cancel")
async def cancel_export(callback: CallbackQuery, state: FSMContext):
    """Отмена процесса экспорта"""
    await callback.answer("Отменено")
    
    logger.info(f"User {callback.from_user.id} cancelled export process")
    
    await state.clear()
    
    await callback.message.edit_text(
        "❌ <b>Процесс экспорта отменен</b>\n\n"
        "Используйте /hosts для начала нового экспорта"
    )

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

import aiohttp
from typing import Dict, List, Optional, Any
from datetime import datetime

from config import (
    YANDEX_ACCESS_TOKEN,
    API_BASE_URL,
    API_TIMEOUT,
    MAX_RETRIES,
    RETRY_DELAY
)
from utils.logger import setup_logger, log_exception

logger = setup_logger(__name__)


class AuthenticationError(Exception):
    """Ошибка аутентификации"""
    pass


class APIError(Exception):
    """Общая ошибка API"""
    pass


class HostInfo:
    """Информация о хосте"""
    
    def __init__(self, data: Dict):
        self.host_id = data.get("host_id", "")
        self.host_url = data.get("host_url", "")
        self.unicode_host_url = data.get("unicode_host_url", "")
        self.verification_state = data.get("verification", {}).get("state", "")
        self.verified = data.get("verified", False)
        self.raw_data = data


ALLOWED_QUERY_INDICATORS = [
    "TOTAL_SHOWS",
    "TOTAL_CLICKS",
    "AVG_SHOW_POSITION",
    "AVG_CLICK_POSITION",
]


class YandexWebmasterAPI:
    """Клиент для работы с Yandex Webmaster API v4"""
    
    def __init__(self):
        self.access_token = YANDEX_ACCESS_TOKEN
        self.base_url = API_BASE_URL
        self.timeout = API_TIMEOUT
        self.max_retries = MAX_RETRIES
        self.retry_delay = RETRY_DELAY
        
        self.headers = {
            "Authorization": f"OAuth {self.access_token}",
            "Content-Type": "application/json"
        }
        
        logger.info(f"✅ YandexWebmasterAPI initialized")
        logger.info(f"   Base URL: {self.base_url}")
        logger.info(f"   Allowed indicators: {', '.join(ALLOWED_QUERY_INDICATORS)}")
    
    async def _make_request(
        self,
        method: str,
        endpoint: str,
        params: Optional[Dict] = None,
        data: Optional[Dict] = None,
        retry_count: int = 0
    ) -> Dict:
        """Выполнение HTTP запроса к API с улучшенной обработкой таймаутов"""
        
        url = f"{self.base_url}{endpoint}"
        
        logger.debug(f"Making {method} request to {endpoint}")
        if params:
            logger.debug(f"Params: {params}")
        
        try:
            # ✅ УВЕЛИЧЕННЫЙ ТАЙМАУТ: разные для connect и total
            timeout = aiohttp.ClientTimeout(
                total=self.timeout,      # Общий таймаут (120 сек)
                connect=30,               # Таймаут подключения (30 сек)
                sock_connect=30,          # Таймаут socket (30 сек)
                sock_read=self.timeout    # Таймаут чтения (120 сек)
            )
            
            async with aiohttp.ClientSession() as session:
                async with session.request(
                    method=method,
                    url=url,
                    headers=self.headers,
                    params=params,
                    json=data,
                    timeout=timeout
                ) as response:
                    
                    logger.debug(f"Response status: {response.status}")
                    
                    if response.status == 401:
                        raise AuthenticationError("Invalid OAuth token")
                    
                    if response.status == 403:
                        raise AuthenticationError("Access forbidden - check token permissions")
                    
                    if response.status == 404:
                        raise APIError(f"Endpoint not found: {endpoint}")
                    
                    if response.status == 400:
                        text = await response.text()
                        logger.error(f"❌ API returned 400 Bad Request")
                        logger.error(f"   Response body: {text}")
                        raise APIError(f"API error {response.status}: {text[:500]}")
                    
                    if response.status >= 500:
                        if retry_count < self.max_retries:
                            logger.warning(f"Server error, retrying... ({retry_count + 1}/{self.max_retries})")
                            import asyncio
                            await asyncio.sleep(self.retry_delay)
                            return await self._make_request(method, endpoint, params, data, retry_count + 1)
                        raise APIError(f"Server error: {response.status}")
                    
                    if response.status != 200:
                        text = await response.text()
                        raise APIError(f"API error {response.status}: {text[:200]}")
                    
                    result = await response.json()
                    return result
        
        # ✅ УЛУЧШЕННАЯ ОБРАБОТКА СЕТЕВЫХ ОШИБОК
        except aiohttp.ClientConnectorError as e:
            error_msg = str(e)
            logger.error(f"❌ Connection error: {error_msg}")
            
            # Retry при таймауте или проблемах с подключением
            if retry_count < self.max_retries:
                logger.warning(f"🔄 Retrying connection... ({retry_count + 1}/{self.max_retries})")
                import asyncio
                await asyncio.sleep(self.retry_delay * (retry_count + 1))  # Увеличиваем задержку
                return await self._make_request(method, endpoint, params, data, retry_count + 1)
            
            raise APIError(f"Network error after {self.max_retries} retries: {error_msg}")
        
        except asyncio.TimeoutError as e:
            logger.error(f"❌ Timeout error after {self.timeout} seconds")
            
            # Retry при таймауте
            if retry_count < self.max_retries:
                logger.warning(f"🔄 Retrying after timeout... ({retry_count + 1}/{self.max_retries})")
                import asyncio
                await asyncio.sleep(self.retry_delay * (retry_count + 1))
                return await self._make_request(method, endpoint, params, data, retry_count + 1)
            
            raise APIError(f"Timeout after {self.max_retries} retries")
        
        except aiohttp.ClientError as e:
            logger.error(f"❌ HTTP client error: {type(e).__name__}: {str(e)}")
            
            # Retry при других клиентских ошибках
            if retry_count < self.max_retries:
                logger.warning(f"🔄 Retrying... ({retry_count + 1}/{self.max_retries})")
                import asyncio
                await asyncio.sleep(self.retry_delay)
                return await self._make_request(method, endpoint, params, data, retry_count + 1)
            
            raise APIError(f"Network error after {self.max_retries} retries: {str(e)}")
        
        except Exception as e:
            logger.error(f"❌ Unexpected error in API request")
            log_exception(logger, e, "_make_request")
            raise
    
        """
    ДОБАВЬТЕ ЭТИ МЕТОДЫ В services/api.py
    В класс YandexWebmasterAPI после существующих методов
    """

    async def get_search_urls_in_search(
        self,
        host_id: str,
        offset: int = 0,
        limit: int = 100
    ) -> Dict:
        """
        Получение примеров страниц в поиске
        
        Endpoint: /user/{user-id}/hosts/{host-id}/search-urls/in-search/samples
        
        Возвращает список URL страниц, которые находятся в поиске
        
        Returns:
            {
                "count": int,
                "samples": [
                    {
                        "url": str,
                        "last_access": str (datetime),
                        "title": str
                    }
                ]
            }
        """
        
        logger.info(f"Fetching pages in search for host {host_id}")
        
        user_data = await self._make_request("GET", "/user")
        user_id = user_data.get("user_id")
        
        params = {
            "offset": offset,
            "limit": min(limit, 100)
        }
        
        logger.debug(f"Search URLs in-search params: {params}")
        
        data = await self._make_request(
            "GET",
            f"/user/{user_id}/hosts/{host_id}/search-urls/in-search/samples",
            params=params
        )
        
        return data


    async def get_search_urls_events(
        self,
        host_id: str,
        offset: int = 0,
        limit: int = 100
    ) -> Dict:
        """
        Получение событий со страницами (добавление/удаление из поиска)
        
        Endpoint: /user/{user-id}/hosts/{host-id}/search-urls/events/samples
        
        Возвращает список событий добавления/удаления страниц в/из поиска
        
        Returns:
            {
                "count": int,
                "samples": [
                    {
                        "url": str,
                        "title": str,
                        "event_date": str (date),
                        "last_access": str (datetime),
                        "event_type": str (APPEARED | EXCLUDED),
                        "excluded_reason": str (optional),
                        "http_code": int (optional),
                        "alternative_url": str (optional)
                    }
                ]
            }
        """
        
        logger.info(f"Fetching page events for host {host_id}")
        
        user_data = await self._make_request("GET", "/user")
        user_id = user_data.get("user_id")
        
        params = {
            "offset": offset,
            "limit": min(limit, 100)
        }
        
        logger.debug(f"Search URLs events params: {params}")
        
        data = await self._make_request(
            "GET",
            f"/user/{user_id}/hosts/{host_id}/search-urls/events/samples",
            params=params
        )
        
        return data


    async def test_connection(self) -> bool:
        """Проверка подключения к API"""
        try:
            await self._make_request("GET", "/user")
            return True
        except Exception as e:
            logger.error(f"Connection test failed: {e}")
            return False
    
    async def get_user_info(self) -> Dict:
        """Получение информации о пользователе"""
        return await self._make_request("GET", "/user")
    
    async def get_user_hosts(self) -> List[HostInfo]:
        """Получение списка хостов пользователя"""
        logger.info("Fetching user hosts...")
        
        user_data = await self._make_request("GET", "/user")
        user_id = user_data.get("user_id")
        
        if not user_id:
            raise APIError("Could not get user_id")
        
        response = await self._make_request("GET", f"/user/{user_id}/hosts")
        
        hosts_data = response.get("hosts", [])
        logger.info(f"Found {len(hosts_data)} hosts")
        
        return [HostInfo(host) for host in hosts_data]
    
    async def get_host_info(self, host_id: str) -> HostInfo:
        """Получение информации о конкретном хосте"""
        logger.info(f"Fetching host info for {host_id}")
        
        user_data = await self._make_request("GET", "/user")
        user_id = user_data.get("user_id")
        
        data = await self._make_request("GET", f"/user/{user_id}/hosts/{host_id}")
        return HostInfo(data)
    
    async def get_host_summary(self, host_id: str) -> Optional[Any]:
        """Получение сводной информации о хосте"""
        logger.info(f"Fetching host summary for {host_id}")
        
        try:
            user_data = await self._make_request("GET", "/user")
            user_id = user_data.get("user_id")
            
            summary = await self._make_request("GET", f"/user/{user_id}/hosts/{host_id}/summary")
            
            class Summary:
                def __init__(self, data: Dict):
                    self.raw_data = data
                    
                    indexing = data.get("indexing_indicators", {})
                    if indexing:
                        self.indexing_indicators = type('obj', (object,), indexing)
                    else:
                        self.indexing_indicators = None
                    
                    search = data.get("search_queries_indicators", {})
                    if search:
                        self.search_query_indicators = type('obj', (object,), search)
                    else:
                        self.search_query_indicators = None
                    
                    links = data.get("links_indicators", {})
                    if links:
                        self.links_indicators = type('obj', (object,), links)
                    else:
                        self.links_indicators = None
            
            return Summary(summary)
            
        except Exception as e:
            logger.warning(f"Could not fetch summary: {e}")
            return None
    
    async def get_search_queries(
        self,
        host_id: str,
        date_from: str,
        date_to: str,
        device_type: str = "ALL",
        limit: int = 100,
        offset: int = 0,
        order_by: str = "TOTAL_SHOWS",
        query_indicator: Optional[List[str]] = None
    ) -> Dict:
        """Получение популярных поисковых запросов"""
        
        logger.debug(f"Fetching search queries: offset={offset}, limit={limit}")
        
        user_data = await self._make_request("GET", "/user")
        user_id = user_data.get("user_id")
        
        if query_indicator is None:
            query_indicator = ALLOWED_QUERY_INDICATORS.copy()
        else:
            invalid = [ind for ind in query_indicator if ind not in ALLOWED_QUERY_INDICATORS]
            if invalid:
                logger.warning(f"⚠️ Removing invalid indicators: {invalid}")
                query_indicator = [ind for ind in query_indicator if ind in ALLOWED_QUERY_INDICATORS]
        
        logger.info(f"📊 Using query indicators: {query_indicator}")
        
        params = {
            "date_from": date_from,
            "date_to": date_to,
            "device_type_indicator": device_type,
            "limit": limit,
            "offset": offset,
            "order_by": order_by
        }
        
        if query_indicator:
            params["query_indicator"] = query_indicator
        
        logger.debug(f"Request params: {params}")
        
        data = await self._make_request(
            "GET",
            f"/user/{user_id}/hosts/{host_id}/search-queries/popular",
            params=params
        )
        
        return data
    
    async def get_search_queries_history(
        self,
        host_id: str,
        query_id: str,
        date_from: str,
        date_to: str,
        device_type: str = "ALL",
        query_indicators: Optional[List[str]] = None
    ) -> Dict:
        """Получение истории для конкретного поискового запроса"""
        
        logger.debug(f"Fetching history for query_id: {query_id[:50]}")
        
        user_data = await self._make_request("GET", "/user")
        user_id = user_data.get("user_id")
        
        if query_indicators is None:
            query_indicators = ALLOWED_QUERY_INDICATORS.copy()
        else:
            invalid = [ind for ind in query_indicators if ind not in ALLOWED_QUERY_INDICATORS]
            if invalid:
                logger.warning(f"⚠️ Removing invalid indicators: {invalid}")
                query_indicators = [ind for ind in query_indicators if ind in ALLOWED_QUERY_INDICATORS]
        
        params = {
            "date_from": date_from,
            "date_to": date_to,
            "device_type_indicator": device_type
        }
        
        if query_indicators:
            params["query_indicator"] = query_indicators
        
        logger.debug(f"History params: {params}")
        
        data = await self._make_request(
            "GET",
            f"/user/{user_id}/hosts/{host_id}/search-queries/{query_id}/history",
            params=params
        )
        
        return data
    
    async def get_search_queries_all_history(
        self,
        host_id: str,
        date_from: str,
        date_to: str,
        device_type: str = "ALL",
        query_indicator: Optional[List[str]] = None
    ) -> Dict:
        """Получение общей статистики для всех поисковых запросов"""
        
        logger.info(f"Fetching all queries history for period {date_from} to {date_to}")
        
        user_data = await self._make_request("GET", "/user")
        user_id = user_data.get("user_id")
        
        if query_indicator is None:
            query_indicator = ALLOWED_QUERY_INDICATORS.copy()
        else:
            invalid = [ind for ind in query_indicator if ind not in ALLOWED_QUERY_INDICATORS]
            if invalid:
                logger.warning(f"⚠️ Removing invalid indicators: {invalid}")
                query_indicator = [ind for ind in query_indicator if ind in ALLOWED_QUERY_INDICATORS]
        
        params = {
            "date_from": date_from,
            "date_to": date_to,
            "device_type_indicator": device_type
        }
        
        if query_indicator:
            params["query_indicator"] = query_indicator
        
        logger.debug(f"All history params: {params}")
        
        data = await self._make_request(
            "GET",
            f"/user/{user_id}/hosts/{host_id}/search-queries/all/history",
            params=params
        )
        
        return data
    
    async def get_search_urls(
        self,
        host_id: str,
        query_id: str,
        date_from: str,
        date_to: str,
        device_type: str = "ALL",
        query_indicators: Optional[List[str]] = None
    ) -> Dict:
        """Получение списка URL для конкретного поискового запроса"""
        
        logger.debug(f"Fetching URLs for query_id: {query_id[:50]}")
        
        user_data = await self._make_request("GET", "/user")
        user_id = user_data.get("user_id")
        
        if query_indicators is None:
            query_indicators = ALLOWED_QUERY_INDICATORS.copy()
        else:
            invalid = [ind for ind in query_indicators if ind not in ALLOWED_QUERY_INDICATORS]
            if invalid:
                logger.warning(f"⚠️ Removing invalid indicators: {invalid}")
                query_indicators = [ind for ind in query_indicators if ind in ALLOWED_QUERY_INDICATORS]
        
        params = {
            "date_from": date_from,
            "date_to": date_to,
            "device_type_indicator": device_type
        }
        
        if query_indicators:
            params["query_indicator"] = query_indicators
        
        logger.debug(f"URLs params: {params}")
        
        data = await self._make_request(
            "GET",
            f"/user/{user_id}/hosts/{host_id}/search-queries/{query_id}/urls",
            params=params
        )
        
        return data

EOF

echo "✅ Сервисы созданы (api.py - часть 1)"

# Продолжение следует...

# ============================================================================
# services/export.py - СЕРВИС ЭКСПОРТА
# ============================================================================
cat > $PROJECT_NAME/services/export.py <<'EOF'

"""
services/export.py - ПОЛНОСТЬЮ ПЕРЕПИСАННАЯ ВЕРСИЯ v4.2 FINAL

Сервис экспорта данных из Yandex Webmaster API

ИЗМЕНЕНИЯ в v4.2 FINAL:
- ✅ ИСПРАВЛЕНО: Корректная обработка page_events с правильными полями API
- ✅ ИСПРАВЛЕНО: event_type теперь APPEARED/EXCLUDED вместо UNKNOWN
- ✅ ИСПРАВЛЕНО: excluded_reason, http_code, alternative_url заполняются корректно
- ✅ Оптимизирован порядок колонок для всех типов экспорта
- ✅ Улучшена обработка индикаторов
- ✅ Добавлена детальная статистика в логах
- ✅ Улучшена обработка ошибок

РЕАЛЬНАЯ СТРУКТУРА API page_events:
{
  "event": "APPEARED_IN_SEARCH",        <- не event_type
  "excluded_url_status": "404 Error",   <- не excluded_reason
  "bad_http_status": 404,               <- не http_code
  "target_url": "https://..."           <- не alternative_url
}
"""

import csv
import json
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Callable, Optional
import asyncio

from config import EXPORTS_DIR, MAX_EXPORT_ROWS, DEFAULT_PAGE_SIZE
from services.api import YandexWebmasterAPI, ALLOWED_QUERY_INDICATORS
from utils.logger import setup_logger, log_exception

logger = setup_logger(__name__)


class ExportService:
    """Сервис для экспорта данных из Yandex Webmaster API"""
    
    def __init__(self, api: YandexWebmasterAPI):
        self.api = api
        logger.info("✅ ExportService initialized (v4.2 FINAL)")
        logger.info(f"   Allowed indicators: {', '.join(ALLOWED_QUERY_INDICATORS)}")
        logger.info(f"   Max export rows: {MAX_EXPORT_ROWS:,}")
        logger.info(f"   Default page size: {DEFAULT_PAGE_SIZE}")
    
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
        """
        Создание экспорта данных
        
        Args:
            host_id: ID хоста
            export_type: Тип экспорта (popular, history, history_all, analytics, enhanced, 
                        pages_in_search, page_events)
            device_type: Тип устройства (ALL, DESKTOP, MOBILE, TABLET)
            date_from: Дата начала (YYYY-MM-DD)
            date_to: Дата окончания (YYYY-MM-DD)
            export_format: Формат файла (csv, xlsx, json)
            progress_callback: Callback для обновления прогресса
            
        Returns:
            str: Путь к созданному файлу
        """
        
        logger.info("=" * 80)
        logger.info(f"🚀 STARTING EXPORT CREATION (v4.2 FINAL)")
        logger.info("=" * 80)
        logger.info(f"Export Type: {export_type}")
        logger.info(f"Device Type: {device_type}")
        logger.info(f"Format: {export_format}")
        logger.info(f"Date Range: {date_from} to {date_to}")
        logger.info(f"Host ID: {host_id}")
        logger.info("=" * 80)
        
        # Маппинг типов экспорта на методы
        export_methods = {
            "popular": self._export_popular_queries,
            "history": self._export_history,
            "history_all": self._export_history_all,
            "analytics": self._export_analytics,
            "enhanced": self._export_enhanced,
            "pages_in_search": self._export_pages_in_search,
            "page_events": self._export_page_events
        }
        
        if export_type not in export_methods:
            raise ValueError(f"Unknown export type: {export_type}. Available: {list(export_methods.keys())}")
        
        # Получение данных
        logger.info(f"📊 Calling export method: {export_type}")
        data = await export_methods[export_type](
            host_id, date_from, date_to, device_type, progress_callback
        )
        
        if not data:
            logger.warning("⚠️ No data collected for export")
        else:
            logger.info(f"✅ Data collected: {len(data):,} records")
        
        # Генерация имени файла
        filename = self._generate_filename(host_id, export_type, export_format)
        file_path = Path(EXPORTS_DIR) / filename
        
        # Сохранение в файл
        save_methods = {
            "csv": self._save_as_csv,
            "xlsx": self._save_as_xlsx,
            "json": self._save_as_json
        }
        
        if export_format not in save_methods:
            raise ValueError(f"Unknown export format: {export_format}. Available: {list(save_methods.keys())}")
        
        logger.info(f"💾 Saving to {export_format.upper()}: {filename}")
        save_methods[export_format](data, file_path, export_type)
        
        # Проверка результата
        if not file_path.exists():
            raise FileNotFoundError(f"Export file was not created: {file_path}")
        
        file_size = file_path.stat().st_size
        
        logger.info("=" * 80)
        logger.info(f"✅ EXPORT COMPLETED SUCCESSFULLY")
        logger.info("=" * 80)
        logger.info(f"File: {file_path}")
        logger.info(f"Size: {file_size:,} bytes")
        logger.info(f"Records: {len(data):,}")
        logger.info("=" * 80)
        
        return str(file_path)
    
    # =========================================================================
    # ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ
    # =========================================================================
    
    def _extract_indicators(self, query: Dict, debug: bool = False) -> Dict:
        """
        Извлечение индикаторов из объекта запроса
        
        Args:
            query: Объект запроса от API
            debug: Включить детальное логирование
            
        Returns:
            Dict с извлеченными индикаторами
        """
        result = {}
        query_text = query.get("query_text", "unknown")
        
        if debug:
            logger.debug("🔍" * 40)
            logger.debug(f"DEBUGGING QUERY: {query_text[:50]}")
            logger.debug(f"Available fields: {list(query.keys())}")
        
        if "indicators" not in query:
            if debug:
                logger.warning(f"❌ NO 'indicators' field in query!")
            return result
        
        indicators = query["indicators"]
        
        if debug:
            logger.debug(f"📊 Found 'indicators' field, type: {type(indicators)}")
        
        if isinstance(indicators, dict):
            for key, value in indicators.items():
                if isinstance(value, (int, float)):
                    result[key] = value
                    if debug:
                        logger.debug(f"   ✅ {key} = {value}")
        else:
            logger.error(f"❌ Unexpected indicators type: {type(indicators)}")
        
        if not result and debug:
            logger.warning(f"⚠️ NO indicators extracted for: {query_text[:50]}")
        
        return result
    
    def _generate_filename(self, host_id: str, export_type: str, export_format: str) -> str:
        """Генерация имени файла для экспорта"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        # Очистка host_id от спецсимволов
        safe_host_id = (
            host_id
            .replace(":", "_")
            .replace("/", "_")
            .replace("https_", "")
            .replace("http_", "")
        )[:50]
        
        return f"export_{safe_host_id}_{export_type}_{timestamp}.{export_format}"
    
    # =========================================================================
    # МЕТОДЫ ЭКСПОРТА ДАННЫХ
    # =========================================================================
    
    async def _export_popular_queries(
        self,
        host_id: str,
        date_from: str,
        date_to: str,
        device_type: str,
        progress_callback: Optional[Callable] = None
    ) -> List[Dict]:
        """
        Экспорт популярных поисковых запросов
        
        Самый простой и быстрый вариант.
        Получает список ТОП запросов с показами, кликами, CTR и позициями.
        """
        
        logger.info("🔥" * 40)
        logger.info("STARTING POPULAR QUERIES EXPORT")
        logger.info("🔥" * 40)
        
        all_queries = []
        offset = 0
        page_size = min(DEFAULT_PAGE_SIZE, 500)
        
        while len(all_queries) < MAX_EXPORT_ROWS:
            try:
                logger.info(f"📥 Fetching queries: offset={offset}, limit={page_size}")
                
                result = await self.api.get_search_queries(
                    host_id=host_id,
                    date_from=date_from,
                    date_to=date_to,
                    device_type=device_type,
                    limit=page_size,
                    offset=offset,
                    order_by="TOTAL_SHOWS",
                    query_indicator=ALLOWED_QUERY_INDICATORS.copy()
                )
                
                queries = result.get("queries", [])
                
                if not queries:
                    logger.info("ℹ️ No more queries available")
                    break
                
                logger.info(f"✅ Got {len(queries)} queries")
                
                for query in queries:
                    row = {
                        "query_id": query.get("query_id", ""),
                        "query_text": query.get("query_text", ""),
                    }
                    
                    # Извлечение индикаторов
                    indicators = self._extract_indicators(query)
                    if indicators:
                        row.update(indicators)
                    
                    all_queries.append(row)
                
                offset += len(queries)
                
                if progress_callback:
                    await progress_callback(
                        len(all_queries),
                        min(result.get("count", 0), MAX_EXPORT_ROWS),
                        f"Загружено запросов: {len(all_queries):,}"
                    )
                
                # Если получили меньше чем запрашивали - это последняя страница
                if len(queries) < page_size:
                    logger.info("✅ Last page reached")
                    break
                
                # Небольшая пауза между запросами
                await asyncio.sleep(0.1)
                
            except Exception as e:
                logger.error(f"❌ ERROR fetching queries at offset {offset}")
                log_exception(logger, e, "_export_popular_queries")
                break
        
        logger.info(f"✅ Popular queries export completed: {len(all_queries):,} records")
        return all_queries[:MAX_EXPORT_ROWS]
    
    async def _export_history(
        self,
        host_id: str,
        date_from: str,
        date_to: str,
        device_type: str,
        progress_callback: Optional[Callable] = None
    ) -> List[Dict]:
        """
        История поисковых запросов
        
        Динамика изменений по ТОП-100 запросам.
        Для каждого запроса получает историю показов/кликов по дням.
        """
        
        logger.info("📈" * 40)
        logger.info("STARTING HISTORY EXPORT")
        logger.info("📈" * 40)
        
        # Сначала получаем ТОП-100 запросов
        logger.info("📊 Step 1: Fetching top 100 queries...")
        result = await self.api.get_search_queries(
            host_id=host_id,
            date_from=date_from,
            date_to=date_to,
            device_type=device_type,
            limit=100,
            offset=0,
            order_by="TOTAL_SHOWS",
            query_indicator=ALLOWED_QUERY_INDICATORS.copy()
        )
        
        top_queries = result.get("queries", [])
        logger.info(f"✅ Got {len(top_queries)} top queries")
        
        history_data = []
        total_queries = len(top_queries)
        
        logger.info("📊 Step 2: Fetching history for each query...")
        
        for idx, query_data in enumerate(top_queries, 1):
            try:
                query_id = query_data.get("query_id")
                query_text = query_data.get("query_text")
                
                if not query_id:
                    logger.warning(f"⚠️ Query without ID: {query_text}")
                    continue
                
                logger.debug(f"Fetching history for query {idx}/{total_queries}: {query_text[:50]}")
                
                # Получаем историю для запроса
                history = await self.api.get_search_queries_history(
                    host_id=host_id,
                    query_id=query_id,
                    date_from=date_from,
                    date_to=date_to,
                    device_type=device_type,
                    query_indicators=ALLOWED_QUERY_INDICATORS.copy()
                )
                
                # Обработка истории
                if "indicators" in history:
                    indicators_obj = history["indicators"]
                    
                    # Собираем все даты
                    all_dates = set()
                    for indicator_name, values_list in indicators_obj.items():
                        if isinstance(values_list, list):
                            for point in values_list:
                                if isinstance(point, dict) and "date" in point:
                                    date_str = point["date"][:10]
                                    all_dates.add(date_str)
                    
                    # Создаем строку для каждой даты
                    for date_str in sorted(all_dates):
                        row = {
                            "query_id": query_id,
                            "query_text": query_text,
                            "date": date_str
                        }
                        
                        # Добавляем значения индикаторов для этой даты
                        for indicator_name, values_list in indicators_obj.items():
                            if isinstance(values_list, list):
                                for point in values_list:
                                    if isinstance(point, dict) and point.get("date", "")[:10] == date_str:
                                        row[indicator_name] = point.get("value", 0)
                                        break
                        
                        history_data.append(row)
                
                # Обновление прогресса каждые 5 запросов
                if progress_callback and idx % 5 == 0:
                    await progress_callback(
                        idx,
                        total_queries,
                        f"Обработано запросов: {idx}/{total_queries}"
                    )
                
                await asyncio.sleep(0.1)
                
            except Exception as e:
                logger.warning(f"⚠️ Error fetching history for query {idx}: {e}")
                continue
        
        logger.info(f"✅ History export completed: {len(history_data):,} data points")
        return history_data
    
    async def _export_history_all(
        self,
        host_id: str,
        date_from: str,
        date_to: str,
        device_type: str,
        progress_callback: Optional[Callable] = None
    ) -> List[Dict]:
        """
        Расширенная история запросов
        
        Общая статистика по ВСЕМ запросам сайта.
        Суммарные показы/клики за каждый день без разбивки по запросам.
        """
        
        logger.info("📊" * 40)
        logger.info("STARTING EXTENDED HISTORY EXPORT")
        logger.info("📊" * 40)
        
        result = await self.api.get_search_queries_all_history(
            host_id=host_id,
            date_from=date_from,
            date_to=date_to,
            device_type=device_type,
            query_indicator=ALLOWED_QUERY_INDICATORS.copy()
        )
        
        all_history = []
        
        if "indicators" in result:
            indicators_obj = result["indicators"]
            
            # Собираем все даты
            all_dates = set()
            for indicator_name, values_list in indicators_obj.items():
                if isinstance(values_list, list):
                    for point in values_list:
                        if isinstance(point, dict) and "date" in point:
                            date_str = point["date"][:10]
                            all_dates.add(date_str)
            
            logger.info(f"📅 Found data for {len(all_dates)} dates")
            
            # Создаем строку для каждой даты
            for date_str in sorted(all_dates):
                row = {"date": date_str}
                
                # Добавляем значения всех индикаторов
                for indicator_name, values_list in indicators_obj.items():
                    if isinstance(values_list, list):
                        for point in values_list:
                            if isinstance(point, dict) and point.get("date", "")[:10] == date_str:
                                row[indicator_name] = point.get("value", 0)
                                break
                
                all_history.append(row)
            
            if progress_callback:
                await progress_callback(
                    len(all_history),
                    len(all_history),
                    f"Обработано дат: {len(all_history)}"
                )
        
        logger.info(f"✅ Extended history completed: {len(all_history):,} data points")
        return all_history
    
    async def _export_analytics(
        self,
        host_id: str,
        date_from: str,
        date_to: str,
        device_type: str,
        progress_callback: Optional[Callable] = None
    ) -> List[Dict]:
        """
        Детальная аналитика с трендами
        
        ТОП-200 запросов с расчетом трендов в %.
        Максимум информации для глубокого анализа.
        """
        
        logger.info("🔬" * 40)
        logger.info("STARTING ANALYTICS EXPORT")
        logger.info("🔬" * 40)
        
        # Получаем ТОП-200 запросов
        logger.info("📊 Fetching top 200 queries...")
        popular_result = await self.api.get_search_queries(
            host_id=host_id,
            date_from=date_from,
            date_to=date_to,
            device_type=device_type,
            limit=200,
            offset=0,
            order_by="TOTAL_SHOWS",
            query_indicator=ALLOWED_QUERY_INDICATORS.copy()
        )
        
        queries = popular_result.get("queries", [])
        logger.info(f"✅ Got {len(queries)} queries")
        
        analytics_data = []
        
        logger.info("📊 Calculating trends for each query...")
        
        for idx, query_data in enumerate(queries, 1):
            try:
                query_text = query_data.get("query_text")
                query_id = query_data.get("query_id")
                
                if not query_text or not query_id:
                    continue
                
                # Базовые данные
                row = {
                    "query_id": query_id,
                    "query_text": query_text,
                }
                
                # Добавляем основные индикаторы
                indicators = self._extract_indicators(query_data)
                if indicators:
                    row.update(indicators)
                
                # Пытаемся рассчитать тренды
                try:
                    history = await self.api.get_search_queries_history(
                        host_id=host_id,
                        query_id=query_id,
                        date_from=date_from,
                        date_to=date_to,
                        device_type=device_type,
                        query_indicators=["TOTAL_SHOWS", "TOTAL_CLICKS"]
                    )
                    
                    if "indicators" in history:
                        indicators_obj = history["indicators"]
                        
                        # Расчет трендов для показов
                        if "TOTAL_SHOWS" in indicators_obj:
                            shows_list = indicators_obj["TOTAL_SHOWS"]
                            if isinstance(shows_list, list) and len(shows_list) >= 2:
                                row["history_points"] = len(shows_list)
                                first_shows = shows_list[0].get("value", 0)
                                last_shows = shows_list[-1].get("value", 0)
                                if first_shows > 0:
                                    trend = ((last_shows - first_shows) / first_shows) * 100
                                    row["shows_trend_percent"] = round(trend, 2)
                        
                        # Расчет трендов для кликов
                        if "TOTAL_CLICKS" in indicators_obj:
                            clicks_list = indicators_obj["TOTAL_CLICKS"]
                            if isinstance(clicks_list, list) and len(clicks_list) >= 2:
                                first_clicks = clicks_list[0].get("value", 0)
                                last_clicks = clicks_list[-1].get("value", 0)
                                if first_clicks > 0:
                                    trend = ((last_clicks - first_clicks) / first_clicks) * 100
                                    row["clicks_trend_percent"] = round(trend, 2)
                
                except Exception as e:
                    logger.debug(f"Could not calculate trends for query {idx}: {e}")
                
                analytics_data.append(row)
                
                # Обновление прогресса
                if progress_callback and idx % 10 == 0:
                    await progress_callback(
                        idx,
                        len(queries),
                        f"Обработано: {idx}/{len(queries)}"
                    )
                
                await asyncio.sleep(0.05)
                
            except Exception as e:
                logger.warning(f"⚠️ Error processing query {idx}: {e}")
                continue
        
        logger.info(f"✅ Analytics completed: {len(analytics_data):,} records")
        return analytics_data
    
    async def _export_enhanced(
        self,
        host_id: str,
        date_from: str,
        date_to: str,
        device_type: str,
        progress_callback: Optional[Callable] = None
    ) -> List[Dict]:
        """
        Расширенный экспорт
        
        До 1,000 запросов с метаданными и временными метками.
        Идеально для архивирования данных.
        """
        
        logger.info("🚀" * 40)
        logger.info("STARTING ENHANCED EXPORT")
        logger.info("🚀" * 40)
        
        all_queries = []
        offset = 0
        page_size = 500
        max_queries = min(MAX_EXPORT_ROWS, 1000)
        
        logger.info(f"📊 Target: up to {max_queries:,} queries")
        
        while len(all_queries) < max_queries:
            try:
                logger.info(f"📥 Fetching: offset={offset}, limit={page_size}")
                
                result = await self.api.get_search_queries(
                    host_id=host_id,
                    date_from=date_from,
                    date_to=date_to,
                    device_type=device_type,
                    limit=page_size,
                    offset=offset,
                    order_by="TOTAL_SHOWS",
                    query_indicator=ALLOWED_QUERY_INDICATORS.copy()
                )
                
                queries = result.get("queries", [])
                if not queries:
                    logger.info("ℹ️ No more queries available")
                    break
                
                logger.info(f"✅ Got {len(queries)} queries")
                all_queries.extend(queries)
                offset += len(queries)
                
                if progress_callback:
                    await progress_callback(
                        len(all_queries),
                        max_queries,
                        f"Загружено: {len(all_queries):,}/{max_queries:,}"
                    )
                
                if len(queries) < page_size:
                    logger.info("✅ Last page reached")
                    break
                
                await asyncio.sleep(0.1)
                
            except Exception as e:
                logger.error(f"❌ Error at offset {offset}")
                log_exception(logger, e, "_export_enhanced")
                break
        
        # Обработка данных с добавлением метаданных
        enhanced_data = []
        export_timestamp = datetime.now().isoformat()
        
        logger.info("📊 Processing queries and adding metadata...")
        
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
                    "export_timestamp": export_timestamp
                }
                
                # Добавляем индикаторы
                indicators = self._extract_indicators(query_data)
                if indicators:
                    row.update(indicators)
                
                enhanced_data.append(row)
                
            except Exception as e:
                logger.warning(f"⚠️ Error processing query {idx}: {e}")
                continue
        
        logger.info(f"✅ Enhanced export completed: {len(enhanced_data):,} records")
        return enhanced_data
    
    async def _export_pages_in_search(
        self,
        host_id: str,
        date_from: str,
        date_to: str,
        device_type: str,
        progress_callback: Optional[Callable] = None
    ) -> List[Dict]:
        """
        Экспорт страниц в поиске
        
        Список URL страниц, которые находятся в индексе Yandex.
        Полезно для аудита индексации.
        """
        
        logger.info("🔗" * 40)
        logger.info("STARTING PAGES IN SEARCH EXPORT")
        logger.info("🔗" * 40)
        logger.info(f"Host ID: {host_id}")
        logger.info("🔗" * 40)
        
        all_pages = []
        offset = 0
        page_size = 100
        
        try:
            while len(all_pages) < MAX_EXPORT_ROWS:
                logger.info(f"📥 Fetching pages: offset={offset}, limit={page_size}")
                
                result = await self.api.get_search_urls_in_search(
                    host_id=host_id,
                    offset=offset,
                    limit=page_size
                )
                
                if not isinstance(result, dict):
                    logger.error(f"❌ Unexpected API response type: {type(result)}")
                    break
                
                total_count = result.get("count", 0)
                samples = result.get("samples", [])
                
                logger.info(f"✅ Got {len(samples)} pages (total available: {total_count:,})")
                
                if not samples:
                    logger.info("ℹ️ No more pages available")
                    break
                
                # Обработка страниц
                for sample in samples:
                    page_data = {
                        "url": sample.get("url", ""),
                        "title": sample.get("title", ""),
                        "last_access": sample.get("last_access", ""),
                        "export_timestamp": datetime.now().isoformat()
                    }
                    all_pages.append(page_data)
                
                offset += len(samples)
                
                if progress_callback:
                    await progress_callback(
                        len(all_pages),
                        min(total_count, MAX_EXPORT_ROWS),
                        f"Загружено страниц: {len(all_pages):,}"
                    )
                
                if len(samples) < page_size:
                    logger.info("✅ Last page reached")
                    break
                
                await asyncio.sleep(0.1)
            
            logger.info("=" * 80)
            logger.info("PAGES IN SEARCH EXPORT COMPLETED")
            logger.info("=" * 80)
            logger.info(f"Total pages: {len(all_pages):,}")
            logger.info("=" * 80)
            
        except Exception as e:
            logger.error("❌ ERROR in pages export")
            log_exception(logger, e, "_export_pages_in_search")
            return []
        
        return all_pages[:MAX_EXPORT_ROWS]
    
    async def _export_page_events(
        self,
        host_id: str,
        date_from: str,
        date_to: str,
        device_type: str,
        progress_callback: Optional[Callable] = None
    ) -> List[Dict]:
        """
        Экспорт событий со страницами (ФИНАЛЬНАЯ ВЕРСИЯ v4.2.1)
        
        РЕАЛЬНАЯ СТРУКТУРА API (из документации):
        {
        "event": "APPEARED_IN_SEARCH" или "REMOVED_FROM_SEARCH",
        "excluded_url_status": "NOTHING_FOUND" (для REMOVED),
        "bad_http_status": 404 (для REMOVED),
        "target_url": "https://..." (для REMOVED)
        }
        
        Типы событий:
        - APPEARED_IN_SEARCH → преобразуется в APPEARED
        - REMOVED_FROM_SEARCH → преобразуется в EXCLUDED
        """
        
        logger.info("📋" * 40)
        logger.info("STARTING PAGE EVENTS EXPORT (v4.2.1)")
        logger.info("📋" * 40)
        logger.info(f"Host ID: {host_id}")
        logger.info("📋" * 40)
        
        all_events = []
        offset = 0
        page_size = 100
        
        try:
            while len(all_events) < MAX_EXPORT_ROWS:
                logger.info(f"📥 Fetching events: offset={offset}, limit={page_size}")
                
                result = await self.api.get_search_urls_events(
                    host_id=host_id,
                    offset=offset,
                    limit=page_size
                )
                
                if not isinstance(result, dict):
                    logger.error(f"❌ Unexpected API response type: {type(result)}")
                    break
                
                total_count = result.get("count", 0)
                samples = result.get("samples", [])
                
                logger.info(f"✅ Got {len(samples)} events (total available: {total_count:,})")
                
                if not samples:
                    logger.info("ℹ️ No more events available")
                    break
                
                # Обработка событий
                for sample in samples:
                    # 1. Тип события (поле "event")
                    raw_event = sample.get("event", "UNKNOWN")
                    
                    # ✅ ИСПРАВЛЕНО: Правильные значения из документации
                    if raw_event == "APPEARED_IN_SEARCH":
                        event_type = "APPEARED"
                    elif raw_event == "REMOVED_FROM_SEARCH":  # ✅ Правильное название!
                        event_type = "EXCLUDED"
                    else:
                        event_type = raw_event  # На случай других значений
                    
                    # 2. Основные поля
                    event_data = {
                        "event_type": event_type,
                        "event_type_raw": raw_event,
                        "event_date": sample.get("event_date", ""),
                        "url": sample.get("url", ""),
                        "title": sample.get("title", ""),
                        "last_access": sample.get("last_access", ""),
                    }
                    
                    # 3. Опциональные поля (только для EXCLUDED/REMOVED)
                    excluded_url_status = sample.get("excluded_url_status")
                    bad_http_status = sample.get("bad_http_status")
                    target_url = sample.get("target_url")
                    
                    # Добавляем поля с дружелюбными названиями
                    if event_type == "EXCLUDED":
                        event_data["excluded_reason"] = excluded_url_status or ""
                        event_data["http_code"] = str(bad_http_status) if bad_http_status else ""
                        event_data["alternative_url"] = target_url or ""
                    else:
                        # Для APPEARED - пустые значения
                        event_data["excluded_reason"] = ""
                        event_data["http_code"] = ""
                        event_data["alternative_url"] = ""
                    
                    # Также сохраняем оригинальные поля
                    event_data["excluded_url_status"] = excluded_url_status or ""
                    event_data["bad_http_status"] = str(bad_http_status) if bad_http_status else ""
                    event_data["target_url"] = target_url or ""
                    
                    # 4. Метаданные
                    event_data["export_timestamp"] = datetime.now().isoformat()
                    
                    all_events.append(event_data)
                
                offset += len(samples)
                
                if progress_callback:
                    await progress_callback(
                        len(all_events),
                        min(total_count, MAX_EXPORT_ROWS),
                        f"Загружено событий: {len(all_events):,}"
                    )
                
                if len(samples) < page_size:
                    logger.info("✅ Last page reached")
                    break
                
                await asyncio.sleep(0.1)
            
            logger.info("=" * 80)
            logger.info("PAGE EVENTS EXPORT COMPLETED")
            logger.info("=" * 80)
            logger.info(f"Total events: {len(all_events):,}")
            
            # Статистика по типам событий
            if len(all_events) > 0:
                event_types_count = {}
                excluded_with_data = 0
                excluded_without_data = 0
                
                for event in all_events:
                    event_type = event.get("event_type", "UNKNOWN")
                    event_types_count[event_type] = event_types_count.get(event_type, 0) + 1
                    
                    if event_type == "EXCLUDED":
                        if event.get("excluded_reason") or event.get("http_code"):
                            excluded_with_data += 1
                        else:
                            excluded_without_data += 1
                
                logger.info("Event types breakdown:")
                for event_type, count in sorted(event_types_count.items()):
                    percentage = (count / len(all_events)) * 100
                    logger.info(f"  {event_type}: {count:,} ({percentage:.1f}%)")
                
                if excluded_with_data > 0:
                    logger.info(f"✅ EXCLUDED events with details: {excluded_with_data:,}")
                
                if excluded_without_data > 0:
                    logger.warning(f"⚠️  EXCLUDED events without details: {excluded_without_data:,}")
                
                # Проверка на UNKNOWN
                unknown_count = event_types_count.get("UNKNOWN", 0)
                if unknown_count > 0:
                    logger.warning(f"⚠️  {unknown_count} events with UNKNOWN type - check API response")
            
            logger.info("=" * 80)
            
        except Exception as e:
            logger.error("❌ ERROR in page events export")
            log_exception(logger, e, "_export_page_events")
            return []
        
        return all_events[:MAX_EXPORT_ROWS]
        
    # =========================================================================
    # МЕТОДЫ СОХРАНЕНИЯ
    # =========================================================================
    
    def _save_as_csv(self, data: List[Dict], file_path: Path, export_type: str = ""):
        """
        Сохранение в CSV с оптимизированным порядком колонок (v4.2)
        
        Args:
            data: Данные для сохранения
            file_path: Путь к файлу
            export_type: Тип экспорта (для оптимизации порядка колонок)
        """
        
        logger.info(f"💾 Saving to CSV: {file_path.name}")
        
        if not data:
            with open(file_path, 'w', encoding='utf-8-sig', newline='') as f:
                writer = csv.writer(f)
                writer.writerow(["No data available"])
            logger.warning("⚠️ Saved empty CSV file")
            return
        
        # Собираем все ключи
        all_keys = set()
        for item in data:
            all_keys.update(item.keys())
        
        # ✅ ОПТИМИЗАЦИЯ: Определяем оптимальный порядок колонок
        
        # Определяем тип экспорта по ключам
        is_page_events = "event_type" in all_keys and "event_date" in all_keys
        is_pages_in_search = "url" in all_keys and "last_access" in all_keys and "event_type" not in all_keys
        is_queries = "query_text" in all_keys or "query_id" in all_keys
        
        if is_page_events:
            logger.info("   Export type: PAGE_EVENTS")
            # ✅ ОБНОВЛЕННЫЙ порядок для событий страниц (v4.2)
            priority_keys = [
                # Первичные ключи
                "event_type",               # Удобочитаемый тип (APPEARED/EXCLUDED)
                "event_type_raw",           # Оригинальное значение API
                "event_date",               # Дата события
                
                # Основная информация
                "url",                      # URL страницы
                "title",                    # Заголовок
                "last_access",              # Последний доступ
                
                # Дружелюбные названия опциональных полей
                "excluded_reason",          # = excluded_url_status
                "http_code",                # = bad_http_status
                "alternative_url",          # = target_url
                
                # Оригинальные поля API (для продвинутых пользователей)
                "excluded_url_status",
                "bad_http_status",
                "target_url",
                
                # Метаданные
                "export_timestamp"
            ]
            
        elif is_pages_in_search:
            logger.info("   Export type: PAGES_IN_SEARCH")
            priority_keys = [
                "url",
                "title",
                "last_access",
                "export_timestamp"
            ]
            
        elif is_queries:
            logger.info("   Export type: QUERIES")
            priority_keys = [
                "query_id",
                "query_text",
                "date",
                "device_type",
                "period_from",
                "period_to",
                # Основные метрики
                "TOTAL_SHOWS",
                "TOTAL_CLICKS",
                "CTR",
                "AVG_SHOW_POSITION",
                "AVG_CLICK_POSITION",
                # Дополнительные метрики
                "history_points",
                "shows_trend_percent",
                "clicks_trend_percent",
                "export_timestamp"
            ]
            
        else:
            logger.info("   Export type: GENERIC")
            priority_keys = []
        
        # Формируем финальный список колонок
        fieldnames = [k for k in priority_keys if k in all_keys]
        
        # Добавляем остальные колонки в алфавитном порядке
        remaining_keys = sorted([k for k in all_keys if k not in priority_keys])
        fieldnames.extend(remaining_keys)
        
        # Сохраняем CSV
        with open(file_path, 'w', encoding='utf-8-sig', newline='') as f:
            writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction='ignore')
            writer.writeheader()
            writer.writerows(data)
        
        logger.info(f"✅ CSV saved successfully")
        logger.info(f"   Rows: {len(data):,}")
        logger.info(f"   Columns: {len(fieldnames)}")
        logger.info(f"   First 5 columns: {', '.join(fieldnames[:5])}")
        
        # Дополнительная статистика для page_events
        if is_page_events:
            appeared_count = sum(1 for row in data if row.get("event_type") == "APPEARED")
            excluded_count = sum(1 for row in data if row.get("event_type") == "EXCLUDED")
            other_count = len(data) - appeared_count - excluded_count
            
            logger.info(f"   Event types:")
            if appeared_count > 0:
                logger.info(f"     APPEARED: {appeared_count:,} ({appeared_count/len(data)*100:.1f}%)")
            if excluded_count > 0:
                logger.info(f"     EXCLUDED: {excluded_count:,} ({excluded_count/len(data)*100:.1f}%)")
            if other_count > 0:
                logger.info(f"     OTHER: {other_count:,} ({other_count/len(data)*100:.1f}%)")
            
            # Процент заполненности опциональных полей
            if excluded_count > 0:
                with_data = sum(
                    1 for row in data 
                    if row.get("event_type") == "EXCLUDED" 
                    and (row.get("excluded_reason") or row.get("http_code"))
                )
                logger.info(f"   Optional fields filled: {with_data}/{excluded_count} EXCLUDED events ({with_data/excluded_count*100:.1f}%)")
    
    def _save_as_xlsx(self, data: List[Dict], file_path: Path, export_type: str = ""):
        """
        Сохранение в Excel с форматированием и автофильтром (v4.2)
        
        Args:
            data: Данные для сохранения
            file_path: Путь к файлу
            export_type: Тип экспорта
        """
        
        logger.info(f"💾 Saving to Excel: {file_path.name}")
        
        try:
            import openpyxl
            from openpyxl.styles import Font, Alignment, PatternFill, Border, Side
            
            wb = openpyxl.Workbook()
            ws = wb.active
            ws.title = "Export Data"
            
            if not data:
                ws['A1'] = "No data available"
                wb.save(file_path)
                logger.warning("⚠️ Saved empty Excel file")
                return
            
            # Используем ту же логику порядка колонок как в CSV
            all_keys = set()
            for item in data:
                all_keys.update(item.keys())
            
            is_page_events = "event_type" in all_keys and "event_date" in all_keys
            is_pages_in_search = "url" in all_keys and "last_access" in all_keys and "event_type" not in all_keys
            is_queries = "query_text" in all_keys or "query_id" in all_keys
            
            if is_page_events:
                priority_keys = [
                    "event_type", "event_type_raw", "event_date",
                    "url", "title", "last_access",
                    "excluded_reason", "http_code", "alternative_url",
                    "excluded_url_status", "bad_http_status", "target_url",
                    "export_timestamp"
                ]
            elif is_pages_in_search:
                priority_keys = ["url", "title", "last_access", "export_timestamp"]
            elif is_queries:
                priority_keys = [
                    "query_id", "query_text", "date",
                    "TOTAL_SHOWS", "TOTAL_CLICKS", "CTR",
                    "AVG_SHOW_POSITION", "AVG_CLICK_POSITION",
                    "history_points", "shows_trend_percent", "clicks_trend_percent"
                ]
            else:
                priority_keys = []
            
            headers = [k for k in priority_keys if k in all_keys]
            headers.extend(sorted([k for k in all_keys if k not in priority_keys]))
            
            # Стили
            header_fill = PatternFill(start_color="366092", end_color="366092", fill_type="solid")
            api_fill = PatternFill(start_color="808080", end_color="808080", fill_type="solid")
            header_font = Font(color="FFFFFF", bold=True, size=11)
            api_font = Font(color="FFFFFF", bold=True, size=10, italic=True)
            
            border = Border(
                left=Side(style='thin'),
                right=Side(style='thin'),
                top=Side(style='thin'),
                bottom=Side(style='thin')
            )
            
            # Заголовки
            for col_idx, header in enumerate(headers, 1):
                cell = ws.cell(row=1, column=col_idx, value=header)
                
                # Разный стиль для оригинальных полей API в page_events
                if is_page_events and header in ["excluded_url_status", "bad_http_status", "target_url", "event_type_raw"]:
                    cell.fill = api_fill
                    cell.font = api_font
                else:
                    cell.fill = header_fill
                    cell.font = header_font
                
                cell.alignment = Alignment(horizontal="center", vertical="center")
                cell.border = border
            
            # Данные
            for row_idx, item in enumerate(data, 2):
                for col_idx, key in enumerate(headers, 1):
                    value = item.get(key)
                    cell = ws.cell(row=row_idx, column=col_idx, value=value)
                    cell.border = border
                    
                    # Форматирование чисел
                    if isinstance(value, (int, float)) and not isinstance(value, bool):
                        if key in ["CTR", "ctr", "clicks_trend_percent", "shows_trend_percent"]:
                            cell.number_format = '0.00"%"'
                        elif isinstance(value, float):
                            cell.number_format = '0.00'
                        else:
                            cell.number_format = '#,##0'
            
            # Авто-ширина колонок
            for column in ws.columns:
                max_length = 0
                column_letter = column[0].column_letter
                for cell in column:
                    if cell.value:
                        max_length = max(max_length, len(str(cell.value)))
                adjusted_width = min(max_length + 2, 50)
                ws.column_dimensions[column_letter].width = adjusted_width
            
            # Закрепление заголовка
            ws.freeze_panes = "A2"
            
            # Автофильтр
            ws.auto_filter.ref = ws.dimensions
            
            wb.save(file_path)
            
            logger.info(f"✅ Excel saved successfully")
            logger.info(f"   Rows: {len(data):,}")
            logger.info(f"   Columns: {len(headers)}")
            logger.info(f"   Features: frozen header, auto-filter, formatted numbers")
            
        except ImportError:
            logger.warning("⚠️ openpyxl not installed, falling back to CSV")
            self._save_as_csv(data, file_path.with_suffix('.csv'), export_type)
    
    def _save_as_json(self, data: List[Dict], file_path: Path, export_type: str = ""):
        """
        Сохранение в JSON с метаданными
        
        Args:
            data: Данные для сохранения
            file_path: Путь к файлу
            export_type: Тип экспорта
        """
        
        logger.info(f"💾 Saving to JSON: {file_path.name}")
        
        # Формируем выходную структуру
        output = {
            "export_metadata": {
                "export_date": datetime.now().isoformat(),
                "export_type": export_type,
                "total_records": len(data),
                "version": "4.2"
            },
            "data": data
        }
        
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(output, f, ensure_ascii=False, indent=2)
        
        logger.info(f"✅ JSON saved successfully")
        logger.info(f"   Records: {len(data):,}")
        logger.info(f"   Format: UTF-8, indented")

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

