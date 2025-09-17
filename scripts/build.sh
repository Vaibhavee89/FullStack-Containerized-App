#!/bin/bash

# Build script for TODO application
# This script builds all Docker images for the application

set -e

echo "🚀 Building TODO Application..."

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

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    print_error "docker-compose is not installed. Please install docker-compose and try again."
    exit 1
fi

# Set environment
ENVIRONMENT=${1:-production}
print_status "Building for environment: $ENVIRONMENT"

# Build images based on environment
if [ "$ENVIRONMENT" = "development" ]; then
    print_status "Building development images..."
    docker-compose -f docker-compose.dev.yml build --no-cache
    print_status "✅ Development images built successfully!"
else
    print_status "Building production images..."
    docker-compose build --no-cache
    print_status "✅ Production images built successfully!"
fi

# Show built images
print_status "Built images:"
docker images | grep -E "(todo-|postgres:|nginx:)"

print_status "🎉 Build completed successfully!"
print_status "To start the application, run: ./scripts/start.sh $ENVIRONMENT"
