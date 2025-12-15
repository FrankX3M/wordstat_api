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
