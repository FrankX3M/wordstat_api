from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker, AsyncSession
from sqlalchemy.orm import DeclarativeBase

from config import DATABASE_URL

# Создание асинхронного движка
engine = create_async_engine(DATABASE_URL, echo=False)

# Создание фабрики сессий
async_session_maker = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False
)


class Base(DeclarativeBase):
    """Базовый класс для моделей"""
    pass


async def init_db():
    """Инициализация базы данных"""
    from database.models import User, Export, HostCache
    
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)


async def get_session() -> AsyncSession:
    """Получение сессии базы данных"""
    async with async_session_maker() as session:
        yield session
