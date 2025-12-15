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
