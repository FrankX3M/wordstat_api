
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

