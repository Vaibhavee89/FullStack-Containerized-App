#!/bin/bash

# Stop script for TODO application
# This script stops the containerized application

set -e

echo "🛑 Stopping TODO Application..."

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
print_status "Stopping application in $ENVIRONMENT mode..."

# Stop services based on environment
if [ "$ENVIRONMENT" = "development" ]; then
    print_status "Stopping development environment..."
    docker-compose -f docker-compose.dev.yml down
else
    print_status "Stopping production environment..."
    docker-compose down
fi

print_status "✅ Application stopped successfully!"

# Option to remove volumes
read -p "Do you want to remove volumes (this will delete all data)? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ "$ENVIRONMENT" = "development" ]; then
        docker-compose -f docker-compose.dev.yml down -v
    else
        docker-compose down -v
    fi
    print_warning "⚠️  All data has been removed!"
fi
