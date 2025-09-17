# Makefile for TODO Application
# Provides convenient commands for managing the containerized application

.PHONY: help build start stop logs clean migrate test

# Default target
help:
	@echo "TODO Application - Docker Management"
	@echo ""
	@echo "Available commands:"
	@echo "  build-prod     Build production images"
	@echo "  build-dev      Build development images"
	@echo "  start-prod     Start production environment"
	@echo "  start-dev      Start development environment"
	@echo "  stop-prod      Stop production environment"
	@echo "  stop-dev       Stop development environment"
	@echo "  logs           Show logs for all services"
	@echo "  logs-service   Show logs for specific service (make logs-service SERVICE=backend)"
	@echo "  migrate-prod   Run database migrations (production)"
	@echo "  migrate-dev    Run database migrations (development)"
	@echo "  clean          Remove all containers and volumes"
	@echo "  test           Run tests"
	@echo "  status         Show service status"

# Build commands
build-prod:
	@./scripts/build.sh production

build-dev:
	@./scripts/build.sh development

# Start commands
start-prod:
	@./scripts/start.sh production

start-dev:
	@./scripts/start.sh development

# Stop commands
stop-prod:
	@./scripts/stop.sh production

stop-dev:
	@./scripts/stop.sh development

# Logs
logs:
	@docker-compose logs -f

logs-dev:
	@docker-compose -f docker-compose.dev.yml logs -f

logs-service:
	@docker-compose logs -f $(SERVICE)

logs-service-dev:
	@docker-compose -f docker-compose.dev.yml logs -f $(SERVICE)

# Database migrations
migrate-prod:
	@./scripts/migrate.sh production

migrate-dev:
	@./scripts/migrate.sh development

# Status
status:
	@docker-compose ps

status-dev:
	@docker-compose -f docker-compose.dev.yml ps

# Clean up
clean:
	@echo "⚠️  This will remove all containers, images, and volumes!"
	@read -p "Are you sure? [y/N]: " confirm && [ "$$confirm" = "y" ]
	@docker-compose down -v --rmi all
	@docker-compose -f docker-compose.dev.yml down -v --rmi all
	@docker system prune -f

# Test commands
test:
	@echo "Running tests..."
	@docker-compose exec backend python -m pytest

test-dev:
	@echo "Running tests in development..."
	@docker-compose -f docker-compose.dev.yml exec backend python -m pytest

# Quick development setup
dev-setup: build-dev start-dev migrate-dev
	@echo "✅ Development environment is ready!"
	@echo "🌐 Frontend: http://localhost:3000"
	@echo "🔧 Backend: http://localhost:8000"

# Quick production setup
prod-setup: build-prod start-prod migrate-prod
	@echo "✅ Production environment is ready!"
	@echo "🌐 Application: http://localhost"
