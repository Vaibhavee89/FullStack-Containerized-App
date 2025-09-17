#!/bin/bash

# Logs script for TODO application
# This script shows logs for the containerized application

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

# Set environment and service
ENVIRONMENT=${1:-production}
SERVICE=${2:-}

if [ -z "$SERVICE" ]; then
    print_status "Showing logs for all services in $ENVIRONMENT mode..."
    if [ "$ENVIRONMENT" = "development" ]; then
        docker-compose -f docker-compose.dev.yml logs -f
    else
        docker-compose logs -f
    fi
else
    print_status "Showing logs for $SERVICE in $ENVIRONMENT mode..."
    if [ "$ENVIRONMENT" = "development" ]; then
        docker-compose -f docker-compose.dev.yml logs -f "$SERVICE"
    else
        docker-compose logs -f "$SERVICE"
    fi
fi
