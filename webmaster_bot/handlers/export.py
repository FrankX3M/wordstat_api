
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

