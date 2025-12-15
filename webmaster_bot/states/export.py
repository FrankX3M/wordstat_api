from aiogram.fsm.state import State, StatesGroup


class ExportStates(StatesGroup):
    """Состояния для процесса экспорта"""
    
    # Выбор хоста
    selecting_host = State()
    
    # Выбор типа экспорта
    selecting_export_type = State()
    
    # Выбор устройства
    selecting_device = State()
    
    # Выбор формата
    selecting_format = State()
    
    # Настройка дат
    setting_date_from = State()
    setting_date_to = State()
    
    # Процесс экспорта
    exporting = State()
    
    # Завершение
    completed = State()
