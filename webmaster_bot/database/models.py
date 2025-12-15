from datetime import datetime
from typing import Optional

from sqlalchemy import String, Integer, BigInteger, DateTime, Boolean, Text, JSON
from sqlalchemy.orm import Mapped, mapped_column

from database import Base


class User(Base):
    """Модель пользователя"""
    __tablename__ = "users"
    
    id: Mapped[int] = mapped_column(BigInteger, primary_key=True)
    username: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    full_name: Mapped[Optional[str]] = mapped_column(String(255), nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    last_activity: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    is_active: Mapped[bool] = mapped_column(Boolean, default=True)
    
    # Статистика
    total_exports: Mapped[int] = mapped_column(Integer, default=0)
    total_requests: Mapped[int] = mapped_column(Integer, default=0)
    
    def __repr__(self):
        return f"<User(id={self.id}, username={self.username})>"


class Export(Base):
    """Модель экспорта данных"""
    __tablename__ = "exports"
    
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(BigInteger, nullable=False)
    host_id: Mapped[str] = mapped_column(String(255), nullable=False)
    host_url: Mapped[str] = mapped_column(String(500), nullable=False)
    
    export_type: Mapped[str] = mapped_column(String(50), nullable=False)
    export_format: Mapped[str] = mapped_column(String(10), default="csv")
    
    # Параметры экспорта
    device_type: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    date_from: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    date_to: Mapped[Optional[str]] = mapped_column(String(20), nullable=True)
    
    # Результаты
    status: Mapped[str] = mapped_column(String(20), default="pending")  # pending, processing, completed, failed
    rows_exported: Mapped[int] = mapped_column(Integer, default=0)
    file_path: Mapped[Optional[str]] = mapped_column(String(500), nullable=True)
    file_size: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)  # в байтах
    
    # Время
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    completed_at: Mapped[Optional[datetime]] = mapped_column(DateTime, nullable=True)
    
    # Ошибки
    error_message: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    
    def __repr__(self):
        return f"<Export(id={self.id}, type={self.export_type}, status={self.status})>"


class HostCache(Base):
    """Кэш информации о хостах"""
    __tablename__ = "host_cache"
    
    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(BigInteger, nullable=False)
    host_id: Mapped[str] = mapped_column(String(255), nullable=False)
    
    # Кэшированные данные
    host_data: Mapped[dict] = mapped_column(JSON, nullable=False)
    summary_data: Mapped[Optional[dict]] = mapped_column(JSON, nullable=True)
    
    # Время
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    expires_at: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    
    def __repr__(self):
        return f"<HostCache(host_id={self.host_id}, user_id={self.user_id})>"
