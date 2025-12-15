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
