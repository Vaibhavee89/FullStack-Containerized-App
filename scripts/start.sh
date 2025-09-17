#!/bin/bash

# Start script for TODO application
# This script starts the containerized application

set -e

echo "🚀 Starting TODO Application..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Set environment
ENVIRONMENT=${1:-production}
print_status "Starting application in $ENVIRONMENT mode..."

# Check if .env file exists
if [ "$ENVIRONMENT" = "development" ]; then
    ENV_FILE=".env.development"
else
    ENV_FILE=".env"
fi

if [ ! -f "$ENV_FILE" ]; then
    print_warning "$ENV_FILE not found. Creating from template..."
    if [ "$ENVIRONMENT" = "development" ]; then
        cp .env.development.example .env.development 2>/dev/null || cp env.example .env.development
    else
        cp env.example .env
    fi
    print_warning "Please update the environment variables in $ENV_FILE before running in production!"
fi

# Start services based on environment
if [ "$ENVIRONMENT" = "development" ]; then
    print_status "Starting development environment..."
    docker-compose -f docker-compose.dev.yml up -d
    
    print_status "Waiting for services to be ready..."
    sleep 10
    
    print_status "Running database migrations..."
    docker-compose -f docker-compose.dev.yml exec backend alembic upgrade head || print_warning "Migration failed - database might not be ready yet"
    
    print_status "✅ Development environment started!"
    print_status "🌐 Frontend: http://localhost:3000"
    print_status "🔧 Backend API: http://localhost:8000"
    print_status "🔧 API Docs: http://localhost:8000/docs"
    print_status "🐘 PostgreSQL: localhost:5432"
else
    print_status "Starting production environment..."
    docker-compose up -d
    
    print_status "Waiting for services to be ready..."
    sleep 15
    
    print_status "Running database migrations..."
    docker-compose exec backend alembic upgrade head || print_warning "Migration failed - database might not be ready yet"
    
    print_status "✅ Production environment started!"
    print_status "🌐 Application: http://localhost"
    print_status "🔧 API Docs: http://localhost/docs"
fi

print_status "📊 To view logs: docker-compose logs -f"
print_status "🛑 To stop: ./scripts/stop.sh $ENVIRONMENT"
