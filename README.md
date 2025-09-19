# TaskMaster - Full-Stack Containerized Todo Application

A modern, production-ready todo application built with **React** frontend, **FastAPI** backend, **PostgreSQL** database, and **Nginx** reverse proxy, all orchestrated with **Docker Compose**.

![TaskMaster](https://img.shields.io/badge/TaskMaster-Full--Stack-blue)
![React](https://img.shields.io/badge/React-18-61dafb)
![FastAPI](https://img.shields.io/badge/FastAPI-Latest-009688)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-336791)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED)
![Nginx](https://img.shields.io/badge/Nginx-Reverse%20Proxy-009639)

## 🏗️ Architecture Overview

This is a **complete full-stack containerized application** with the following components:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Nginx Proxy   │────│  React Frontend │    │  FastAPI Backend│────│  PostgreSQL DB  │
│   (Port 80/443) │    │   (Port 3000)   │    │   (Port 8000)   │    │   (Port 5432)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
```

### ✅ Implemented Features

#### 🎯 **Full-Stack Containerized App**
- **React Frontend** - Modern React 18 with Tailwind CSS
- **FastAPI Backend** - High-performance Python API with auto-documentation
- **PostgreSQL Database** - Production-ready database with proper initialization
- **Nginx Reverse Proxy** - Load balancing, rate limiting, and security headers
- **Docker Compose Orchestration** - Complete container orchestration with health checks
- **Environment Configurations** - Flexible environment-based configuration

#### 🔧 **Technical Stack**

**Frontend (React)**
- React 18 with functional components and hooks
- React Router v6 for client-side routing
- Axios for HTTP client
- Lucide React for beautiful icons
- Tailwind CSS for styling
- Multi-stage Docker build for optimization

**Backend (FastAPI)**
- FastAPI with automatic API documentation
- SQLAlchemy ORM with PostgreSQL support
- JWT authentication with refresh tokens
- Email verification system
- Admin panel with user management
- Rate limiting and security middleware
- Alembic for database migrations

**Database (PostgreSQL)**
- PostgreSQL 15 Alpine image
- Proper initialization scripts
- Database extensions (UUID, trigram)
- Health checks and connection pooling
- Persistent volumes for data

**Reverse Proxy (Nginx)**
- Load balancing between services
- Rate limiting for API endpoints
- Security headers (XSS, CSRF protection)
- Gzip compression
- Static asset caching
- SSL/HTTPS ready configuration

**Container Orchestration**
- Docker Compose with separate dev/prod environments
- Health checks for all services
- Proper networking between containers
- Volume management for data persistence
- Development hot-reload support

## 🚀 Quick Start

### Prerequisites
- **Docker** and **Docker Compose** installed
- **Git** for cloning the repository
- **Make** (optional, for convenience commands)

### 1. Clone and Setup
```bash
git clone <your-repo-url>
cd TODO_API
```

### 2. Environment Configuration
```bash
# Copy environment template
cp env.example .env

# Edit environment variables (optional - defaults work for development)
nano .env
```

### 3. Start the Application

#### Option A: Using Make (Recommended)
```bash
# Development environment (with hot reload)
make dev-setup

# Production environment
make prod-setup
```

#### Option B: Using Docker Compose Directly
```bash
# Development environment
docker-compose -f docker-compose.dev.yml up --build

# Production environment
docker-compose up --build
```

### 4. Access the Application

After starting, the application will be available at:

**Development:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/docs

**Production:**
- Application: http://localhost (via Nginx)
- API Docs: http://localhost/docs

## 🎯 Feature Testing Guide

### 1. **User Registration & Authentication**
1. Navigate to the frontend
2. Click "Register" to create a new account
3. Check console/logs for email verification link
4. Verify email and login with credentials

### 2. **Todo Management**
1. Login to your account
2. Create new todos using the form
3. Mark todos as complete/incomplete
4. Edit todo titles and descriptions
5. Delete todos you no longer need

### 3. **Admin Panel** (Admin Users Only)
1. Promote a user to admin (use admin scripts)
2. Access admin dashboard
3. View all users and their statistics
4. Manage user accounts

### 4. **API Documentation**
1. Visit http://localhost:8000/docs (dev) or http://localhost/docs (prod)
2. Test API endpoints directly from the Swagger UI
3. Authenticate using the "Authorize" button

### 5. **Database Verification**
```bash
# Check database connection and users
docker-compose exec backend python check_users.py

# Debug authentication
docker-compose exec backend python debug_auth.py
```

## 🛠️ Development Commands

### Using Makefile (Recommended)
```bash
# Development
make dev-setup          # Build, start, and migrate dev environment
make logs-dev           # View development logs
make status-dev         # Check service status
make stop-dev           # Stop development environment

# Production
make prod-setup         # Build, start, and migrate production
make logs               # View production logs
make status             # Check service status
make stop-prod          # Stop production environment

# Database
make migrate-dev        # Run migrations in development
make migrate-prod       # Run migrations in production

# Cleanup
make clean              # Remove all containers and volumes
```

### Using Docker Compose Directly
```bash
# Development
docker-compose -f docker-compose.dev.yml up --build -d
docker-compose -f docker-compose.dev.yml logs -f
docker-compose -f docker-compose.dev.yml down

# Production
docker-compose up --build -d
docker-compose logs -f
docker-compose down

# Database migrations
docker-compose exec backend alembic upgrade head
```

## 📊 Service Architecture Details

### **Frontend Container**
- **Base Image**: Node.js 18 Alpine
- **Multi-stage Build**: Optimized production build with Nginx
- **Development**: Hot reload with volume mounting
- **Port**: 3000 (dev) / 80 (prod via Nginx)

### **Backend Container**
- **Base Image**: Python 3.11 Slim
- **Features**: FastAPI with auto-reload in development
- **Database**: PostgreSQL with connection pooling
- **Port**: 8000
- **Health Check**: `/health` endpoint

### **Database Container**
- **Base Image**: PostgreSQL 15 Alpine
- **Features**: Persistent volumes, initialization scripts
- **Extensions**: UUID, trigram for search
- **Port**: 5432
- **Health Check**: `pg_isready`

### **Nginx Container**
- **Base Image**: Nginx Alpine
- **Features**: Reverse proxy, load balancing, SSL ready
- **Security**: Rate limiting, security headers
- **Port**: 80/443
- **Health Check**: Custom health endpoint

## 🔧 Configuration

### Environment Variables
```bash
# Database
DATABASE_URL=postgresql://todouser:todopass@postgres:5432/todoapp
POSTGRES_USER=todouser
POSTGRES_PASSWORD=todopass
POSTGRES_DB=todoapp

# Application
SECRET_KEY=your-super-secret-key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
ENVIRONMENT=production
DEBUG=false

# CORS
CORS_ORIGINS=http://localhost:3000,http://localhost:80

# Rate Limiting
RATE_LIMIT_REQUESTS=100
RATE_LIMIT_WINDOW=60
```

### Nginx Configuration
- **Rate Limiting**: 10 req/s for API, 1 req/s for auth
- **Security Headers**: XSS protection, content type options
- **Compression**: Gzip for text-based files
- **Caching**: 1 year for static assets

## 🗄️ Database Schema

### Users Table
```sql
- id (Primary Key)
- username (Unique)
- email (Unique)
- hashed_password (Bcrypt)
- is_active (Email verification)
- is_admin (Admin privileges)
- created_at (Timestamp)
- updated_at (Auto-updated)
```

### Todos Table
```sql
- id (Primary Key)
- title (Task title)
- description (Optional description)
- completed (Boolean)
- owner_id (Foreign Key to Users)
- created_at (Timestamp)
- updated_at (Auto-updated)
```

## 🚀 Deployment

### Production Deployment
1. **Set Environment Variables**:
   ```bash
   cp env.example .env
   # Edit .env with production values
   ```

2. **Build and Start**:
   ```bash
   make prod-setup
   ```

3. **SSL/HTTPS Setup**:
   - Place SSL certificates in `nginx/ssl/`
   - Update Nginx configuration for HTTPS
   - Set `CORS_ORIGINS` to your domain

### Cloud Deployment
- **AWS**: Use ECS/EKS with RDS
- **DigitalOcean**: App Platform or Droplets
- **Heroku**: Use PostgreSQL addon
- **Railway**: Direct deployment with PostgreSQL

## 🧪 Testing

### Manual Testing
```bash
# Test API endpoints
curl http://localhost:8000/health

# Test authentication
curl -X POST http://localhost:8000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test","email":"test@example.com","password":"testpass"}'
```

### Automated Testing
```bash
# Run backend tests
docker-compose exec backend python -m pytest

# Run frontend tests
docker-compose exec frontend npm test
```

## 🐛 Troubleshooting

### Common Issues

1. **Port Conflicts**
   ```bash
   # Check what's using the ports
   lsof -i :3000
   lsof -i :8000
   lsof -i :80
   ```

2. **Database Connection Issues**
   ```bash
   # Check database logs
   docker-compose logs postgres
   
   # Test database connection
   docker-compose exec postgres psql -U todouser -d todoapp
   ```

3. **Frontend Not Loading**
   ```bash
   # Check frontend logs
   docker-compose logs frontend
   
   # Rebuild frontend
   docker-compose build frontend --no-cache
   ```

4. **API Not Responding**
   ```bash
   # Check backend logs
   docker-compose logs backend
   
   # Test health endpoint
   curl http://localhost:8000/health
   ```

### Debug Commands
```bash
# Check all service status
docker-compose ps

# View logs for specific service
docker-compose logs -f backend

# Execute commands in containers
docker-compose exec backend bash
docker-compose exec postgres psql -U todouser -d todoapp

# Check database users
docker-compose exec backend python check_users.py
```

## 📚 API Documentation

### Authentication Endpoints
- `POST /auth/register` - Register new user
- `POST /auth/token` - Login and get access token
- `GET /auth/verify-email` - Verify email address

### Todo Endpoints
- `GET /todos/` - List user's todos
- `POST /todos/` - Create new todo
- `GET /todos/{id}` - Get specific todo
- `PUT /todos/{id}` - Update todo
- `DELETE /todos/{id}` - Delete todo

### Admin Endpoints
- `GET /admin/users` - List all users (admin only)
- `POST /admin/users/{id}/promote` - Promote user to admin
- `DELETE /admin/users/{id}` - Delete user

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes and commit: `git commit -m 'Add feature'`
4. Push to the branch: `git push origin feature-name`
5. Submit a pull request

### Development Guidelines
- Follow existing code style and patterns
- Add proper error handling and validation
- Include appropriate comments and documentation
- Test authentication flows thoroughly
- Ensure responsive design for frontend changes

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**TaskMaster** - Organize your life, together. 🎯

*Built with ❤️ using React, FastAPI, PostgreSQL, and Docker*