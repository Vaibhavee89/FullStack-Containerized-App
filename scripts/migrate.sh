#!/bin/bash

# Database migration script for TODO application
# This script handles database migrations in the containerized environment

set -e

echo "🗃️ Running Database Migrations..."

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

# Set environment
ENVIRONMENT=${1:-production}
COMMAND=${2:-upgrade}

print_status "Running migrations in $ENVIRONMENT mode..."

# Run migrations based on environment
if [ "$ENVIRONMENT" = "development" ]; then
    if [ "$COMMAND" = "init" ]; then
        print_status "Initializing Alembic..."
        docker-compose -f docker-compose.dev.yml exec backend alembic init alembic
    elif [ "$COMMAND" = "revision" ]; then
        MESSAGE=${3:-"Auto migration"}
        print_status "Creating new migration: $MESSAGE"
        docker-compose -f docker-compose.dev.yml exec backend alembic revision --autogenerate -m "$MESSAGE"
    else
        print_status "Running database upgrade..."
        docker-compose -f docker-compose.dev.yml exec backend alembic upgrade head
    fi
else
    if [ "$COMMAND" = "init" ]; then
        print_status "Initializing Alembic..."
        docker-compose exec backend alembic init alembic
    elif [ "$COMMAND" = "revision" ]; then
        MESSAGE=${3:-"Auto migration"}
        print_status "Creating new migration: $MESSAGE"
        docker-compose exec backend alembic revision --autogenerate -m "$MESSAGE"
    else
        print_status "Running database upgrade..."
        docker-compose exec backend alembic upgrade head
    fi
fi

print_status "✅ Migration completed successfully!"
