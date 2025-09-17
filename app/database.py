import os
import logging
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from sqlalchemy.exc import OperationalError
import time

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Get database URL from environment variable with fallback for local development
DATABASE_URL = os.getenv("DATABASE_URL")

# If no DATABASE_URL is set, use SQLite for local development
if not DATABASE_URL:
    DATABASE_URL = "sqlite:///./todo_multiuser.db"
    logger.info("🔄 Using SQLite database for local development")
    engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
else:
    # For PostgreSQL (containerized or remote)
    if "postgresql" in DATABASE_URL.lower():
        logger.info("🐘 Using PostgreSQL database")
        
        # Database connection with retry logic for containerized environments
        def create_postgres_engine(database_url, max_retries=5, retry_delay=5):
            for attempt in range(max_retries):
                try:
                    engine = create_engine(
                        database_url,
                        pool_pre_ping=True,
                        pool_recycle=300,
                        pool_size=10,
                        max_overflow=20,
                        echo=os.getenv("DEBUG", "false").lower() == "true"
                    )
                    # Test the connection
                    with engine.connect() as conn:
                        conn.execute("SELECT 1")
                    logger.info(f"✅ Successfully connected to PostgreSQL database")
                    return engine
                except OperationalError as e:
                    if attempt < max_retries - 1:
                        logger.warning(f"⏳ Database connection attempt {attempt + 1} failed. Retrying in {retry_delay} seconds...")
                        time.sleep(retry_delay)
                    else:
                        logger.error(f"❌ Failed to connect to database after {max_retries} attempts: {e}")
                        raise
            return None
        
        engine = create_postgres_engine(DATABASE_URL)
    else:
        # Fallback for other database types
        engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)
Base = declarative_base()

# dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_database_info():
    """Get information about the current database connection"""
    return {
        "database_url": DATABASE_URL,
        "engine": str(engine.url),
        "is_postgresql": "postgresql" in DATABASE_URL.lower(),
        "is_sqlite": "sqlite" in DATABASE_URL.lower(),
        "pool_size": getattr(engine.pool, 'size', lambda: 'N/A')(),
        "checked_out": getattr(engine.pool, 'checkedout', lambda: 'N/A')()
    }
