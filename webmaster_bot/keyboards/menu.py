
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

