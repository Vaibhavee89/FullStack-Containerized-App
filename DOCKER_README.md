# TODO Application - Containerized Full-Stack Setup

This document provides comprehensive instructions for running the TODO application as a containerized full-stack application with PostgreSQL database, Nginx reverse proxy, and Docker Compose orchestration.

## 🏗️ Architecture

The application consists of the following services:

- **Frontend**: React application served by Nginx
- **Backend**: FastAPI application with authentication and CRUD operations
- **Database**: PostgreSQL 15 with persistent storage
- **Reverse Proxy**: Nginx for routing and load balancing

## 📋 Prerequisites

- Docker (version 20.10 or higher)
- Docker Compose (version 2.0 or higher)
- Git

## 🚀 Quick Start

### 1. Clone and Setup

```bash
git clone <your-repo-url>
cd TODO_API
```

### 2. Environment Configuration

Copy the environment template and configure your settings:

```bash
# For production
cp env.example .env

# For development
cp .env.development .env.development
```

**Important**: Update the following variables in your `.env` file:
- `SECRET_KEY`: Use a secure random key for production
- `POSTGRES_PASSWORD`: Set a strong password
- Email configuration (if using email features)

### 3. Build and Start

#### Production Environment
```bash
# Build all services
./scripts/build.sh production

# Start the application
./scripts/start.sh production
```

#### Development Environment
```bash
# Build development services
./scripts/build.sh development

# Start in development mode
./scripts/start.sh development
```

### 4. Access the Application

#### Production Mode
- **Main Application**: http://localhost
- **API Documentation**: http://localhost/docs
- **API Redoc**: http://localhost/redoc

#### Development Mode
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **PostgreSQL**: localhost:5432

## 🛠️ Management Scripts

### Build Services
```bash
./scripts/build.sh [production|development]
```

### Start Application
```bash
./scripts/start.sh [production|development]
```

### Stop Application
```bash
./scripts/stop.sh [production|development]
```

### View Logs
```bash
# All services
./scripts/logs.sh [production|development]

# Specific service
./scripts/logs.sh [production|development] [service-name]
```

### Database Migrations
```bash
# Run migrations
./scripts/migrate.sh [production|development]

# Create new migration
./scripts/migrate.sh [production|development] revision "Migration message"
```

## 🗂️ Project Structure

```
TODO_API/
├── app/                    # FastAPI backend application
├── frontend/              # React frontend application
├── nginx/                 # Nginx configuration
│   ├── nginx.conf
│   └── conf.d/
├── scripts/               # Management scripts
├── alembic/              # Database migrations
├── docker-compose.yml    # Production orchestration
├── docker-compose.dev.yml # Development orchestration
├── Dockerfile            # Backend production image
├── Dockerfile.dev        # Backend development image
├── init-db.sql          # Database initialization
├── env.example          # Environment template
└── .env.development     # Development environment
```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | Auto-generated |
| `SECRET_KEY` | JWT secret key | **Required** |
| `POSTGRES_USER` | Database username | `todouser` |
| `POSTGRES_PASSWORD` | Database password | `todopass` |
| `POSTGRES_DB` | Database name | `todoapp` |
| `ENVIRONMENT` | Application environment | `production` |
| `DEBUG` | Enable debug mode | `false` |

### Service Ports

| Service | Production Port | Development Port |
|---------|----------------|------------------|
| Nginx Proxy | 80, 443 | N/A |
| Frontend | Internal | 3000 |
| Backend | Internal | 8000 |
| PostgreSQL | 5432 | 5432 |

## 🔒 Security Features

- **Rate Limiting**: API endpoints have rate limiting configured
- **CORS Protection**: Configured for allowed origins
- **Security Headers**: X-Frame-Options, XSS Protection, etc.
- **Non-root Containers**: All services run as non-root users
- **Health Checks**: All services have health check endpoints

## 📊 Monitoring and Logging

### View Service Status
```bash
docker-compose ps
```

### Monitor Resource Usage
```bash
docker stats
```

### Access Container Shells
```bash
# Backend
docker-compose exec backend bash

# Frontend
docker-compose exec frontend sh

# Database
docker-compose exec postgres psql -U todouser -d todoapp
```

## 🐛 Troubleshooting

### Common Issues

1. **Database Connection Failed**
   - Ensure PostgreSQL container is healthy: `docker-compose ps`
   - Check logs: `./scripts/logs.sh production postgres`
   - Verify environment variables in `.env`

2. **Frontend Not Loading**
   - Check Nginx configuration
   - Verify frontend build completed successfully
   - Check logs: `./scripts/logs.sh production frontend`

3. **API Endpoints Not Working**
   - Verify backend is running: `curl http://localhost:8000/health`
   - Check backend logs: `./scripts/logs.sh production backend`
   - Ensure database migrations ran successfully

4. **Permission Errors**
   - Ensure scripts are executable: `chmod +x scripts/*.sh`
   - Check Docker daemon is running

### Reset Everything
```bash
# Stop all services and remove volumes (⚠️ This deletes all data)
docker-compose down -v

# Remove all images
docker-compose down --rmi all

# Rebuild from scratch
./scripts/build.sh production
./scripts/start.sh production
```

## 🚀 Production Deployment

### SSL/HTTPS Setup

1. Obtain SSL certificates (Let's Encrypt recommended)
2. Place certificates in `nginx/ssl/`
3. Update `nginx/conf.d/default.conf` for HTTPS
4. Restart Nginx: `docker-compose restart nginx`

### Performance Optimization

- **Database**: Tune PostgreSQL settings in `docker-compose.yml`
- **Nginx**: Enable caching and compression (already configured)
- **Backend**: Adjust worker processes and connection pools
- **Monitoring**: Add monitoring tools (Prometheus, Grafana)

### Backup Strategy

```bash
# Database backup
docker-compose exec postgres pg_dump -U todouser todoapp > backup.sql

# Restore database
docker-compose exec -T postgres psql -U todouser todoapp < backup.sql
```

## 📝 Development

### Hot Reload Development

The development environment supports hot reload for both frontend and backend:

- **Frontend**: React development server with hot reload
- **Backend**: Uvicorn with `--reload` flag
- **Database**: Persistent volume for data

### Adding New Features

1. Make changes to your code
2. For backend changes: Code reloads automatically
3. For frontend changes: React development server reloads
4. For database changes: Create migration with `./scripts/migrate.sh development revision "Description"`

## 🤝 Contributing

1. Use development environment for testing
2. Ensure all services start successfully
3. Run tests before committing
4. Update documentation for new features

## 📞 Support

For issues and questions:
1. Check the troubleshooting section
2. Review service logs
3. Verify environment configuration
4. Check Docker and Docker Compose versions
