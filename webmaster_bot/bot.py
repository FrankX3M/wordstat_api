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
