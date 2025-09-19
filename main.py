from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager
from app.routers import todos, admin, users
from app.database import engine, get_database_info
from app import models
from app.scheduler import start_scheduler, stop_scheduler

# CORS configuration for local development
origins = [
    "http://localhost:3000",
    "http://localhost:80",
    "http://localhost"
]

# Create tables (use Alembic for migrations in production)
models.Base.metadata.create_all(bind=engine)

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    await start_scheduler()
    yield
    # Shutdown
    await stop_scheduler()

app = FastAPI(title="TaskMaster API", version="1.0.0", lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(users.router)
app.include_router(todos.router)
app.include_router(admin.router)

# Root endpoint
@app.get("/")
def read_root():
    return {"message": "TaskMaster API is running!", "docs": "/docs"}

# Health check endpoint
@app.get("/health")
async def health_check():
    db_info = get_database_info()
    return {
        "status": "healthy", 
        "service": "taskmaster-backend",
        "database": {
            "type": "PostgreSQL" if db_info["is_postgresql"] else "SQLite",
            "connected": True
        }
    }
