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
