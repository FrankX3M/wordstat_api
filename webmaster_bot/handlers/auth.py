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
