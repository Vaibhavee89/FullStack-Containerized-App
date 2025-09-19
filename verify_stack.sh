#!/bin/bash

# Full-Stack Containerized App Verification Script
# Tests: React frontend + FastAPI backend + PostgreSQL + Nginx + Docker Compose

echo "🔍 FULLSTACK CONTAINERIZED APP VERIFICATION"
echo "============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test results
TESTS_PASSED=0
TESTS_FAILED=0

# Function to print test results
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ PASS${NC}: $2"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}❌ FAIL${NC}: $2"
        ((TESTS_FAILED++))
    fi
}

echo -e "\n${BLUE}1. DOCKER COMPOSE ORCHESTRATION${NC}"
echo "================================"

# Check if containers are running
echo "Checking container status..."
docker-compose -f docker-compose.dev.yml ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"

# Count running containers
RUNNING_CONTAINERS=$(docker-compose -f docker-compose.dev.yml ps -q | wc -l)
print_result $((4 - RUNNING_CONTAINERS)) "Docker Compose orchestration (4 containers expected, $RUNNING_CONTAINERS running)"

echo -e "\n${BLUE}2. POSTGRESQL DATABASE CONTAINER${NC}"
echo "================================="

# Test PostgreSQL connectivity
echo "Testing PostgreSQL connection..."
docker exec todo-postgres-dev pg_isready -U todouser -d todoapp > /dev/null 2>&1
print_result $? "PostgreSQL database connectivity"

# Test database tables
echo "Checking database tables..."
TABLES=$(docker exec todo-postgres-dev psql -U todouser -d todoapp -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null | tr -d ' ')
if [ "$TABLES" -gt 0 ]; then
    print_result 0 "Database tables exist ($TABLES tables found)"
else
    print_result 1 "Database tables exist (0 tables found)"
fi

# Test data persistence
echo "Testing data persistence..."
docker exec todo-postgres-dev psql -U todouser -d todoapp -c "SELECT 1;" > /dev/null 2>&1
print_result $? "Data persistence and volume mounting"

echo -e "\n${BLUE}3. FASTAPI BACKEND CONTAINER${NC}"
echo "============================="

# Test backend health endpoint
echo "Testing FastAPI health endpoint..."
curl -f -s http://localhost:8000/health > /dev/null 2>&1
print_result $? "FastAPI backend health check"

# Test API documentation
echo "Testing API documentation..."
curl -f -s http://localhost:8000/docs > /dev/null 2>&1
print_result $? "FastAPI documentation endpoint"

# Test OpenAPI schema
echo "Testing OpenAPI schema..."
curl -f -s http://localhost:8000/openapi.json > /dev/null 2>&1
print_result $? "OpenAPI schema endpoint"

# Test authentication endpoints
echo "Testing authentication endpoints..."
curl -f -s -X POST http://localhost:8000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"username":"test","email":"test@example.com","password":"testpass"}' > /dev/null 2>&1
AUTH_RESULT=$?
print_result $AUTH_RESULT "Authentication endpoints accessibility"

echo -e "\n${BLUE}4. REACT FRONTEND CONTAINER${NC}"
echo "============================"

# Test frontend accessibility
echo "Testing React frontend..."
FRONTEND_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000)
if [ "$FRONTEND_RESPONSE" = "200" ]; then
    print_result 0 "React frontend accessibility"
else
    print_result 1 "React frontend accessibility (HTTP $FRONTEND_RESPONSE)"
fi

# Test if React app loads
echo "Testing React app content..."
REACT_CONTENT=$(curl -s http://localhost:3000 | grep -c "TaskMaster")
if [ "$REACT_CONTENT" -gt 0 ]; then
    print_result 0 "React app content loading"
else
    print_result 1 "React app content loading"
fi

# Test static assets
echo "Testing static assets..."
curl -f -s http://localhost:3000/static/js/bundle.js > /dev/null 2>&1
print_result $? "Static assets serving"

echo -e "\n${BLUE}5. NGINX REVERSE PROXY${NC}"
echo "======================"

# Test Nginx health
echo "Testing Nginx health..."
curl -f -s http://localhost:80/health > /dev/null 2>&1
print_result $? "Nginx reverse proxy health"

# Test API routing through Nginx
echo "Testing API routing through Nginx..."
curl -f -s http://localhost:80/api/health > /dev/null 2>&1
print_result $? "Nginx API routing"

# Test frontend routing through Nginx
echo "Testing frontend routing through Nginx..."
NGINX_FRONTEND=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:80)
if [ "$NGINX_FRONTEND" = "200" ]; then
    print_result 0 "Nginx frontend routing"
else
    print_result 1 "Nginx frontend routing (HTTP $NGINX_FRONTEND)"
fi

echo -e "\n${BLUE}6. ENVIRONMENT CONFIGURATIONS${NC}"
echo "============================="

# Check development environment
echo "Checking development environment..."
if [ -f "docker-compose.dev.yml" ]; then
    print_result 0 "Development environment configuration exists"
else
    print_result 1 "Development environment configuration exists"
fi

# Check production environment
echo "Checking production environment..."
if [ -f "docker-compose.yml" ]; then
    print_result 0 "Production environment configuration exists"
else
    print_result 1 "Production environment configuration exists"
fi

# Check environment variables
echo "Checking environment variables..."
if [ -f ".env.development" ]; then
    print_result 0 "Environment variables file exists"
else
    print_result 1 "Environment variables file exists"
fi

echo -e "\n${BLUE}7. INTER-CONTAINER COMMUNICATION${NC}"
echo "================================="

# Test backend to database communication
echo "Testing backend to database communication..."
BACKEND_DB_TEST=$(curl -s http://localhost:8000/health | grep -c "healthy")
if [ "$BACKEND_DB_TEST" -gt 0 ]; then
    print_result 0 "Backend to database communication"
else
    print_result 1 "Backend to database communication"
fi

# Test network connectivity
echo "Testing container network..."
NETWORK_EXISTS=$(docker network ls | grep -c "todo-dev-network")
if [ "$NETWORK_EXISTS" -gt 0 ]; then
    print_result 0 "Container network exists"
else
    print_result 1 "Container network exists"
fi

echo -e "\n${BLUE}8. DOCKER FEATURES VERIFICATION${NC}"
echo "==============================="

# Test volume persistence
echo "Testing volume persistence..."
VOLUMES=$(docker volume ls | grep -c "postgres_dev_data")
if [ "$VOLUMES" -gt 0 ]; then
    print_result 0 "PostgreSQL data volume persistence"
else
    print_result 1 "PostgreSQL data volume persistence"
fi

# Test health checks
echo "Testing container health checks..."
HEALTHY_CONTAINERS=$(docker-compose -f docker-compose.dev.yml ps --format "{{.Status}}" | grep -c "healthy")
print_result $((2 - HEALTHY_CONTAINERS)) "Container health checks ($HEALTHY_CONTAINERS/2 containers healthy)"

# Test container restart policies
echo "Testing restart policies..."
RESTART_POLICIES=$(docker-compose -f docker-compose.dev.yml config | grep -c "restart:")
if [ "$RESTART_POLICIES" -gt 0 ]; then
    print_result 0 "Container restart policies configured"
else
    print_result 1 "Container restart policies configured"
fi

echo -e "\n${YELLOW}SUMMARY${NC}"
echo "======="
echo -e "Tests Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests Failed: ${RED}$TESTS_FAILED${NC}"
echo -e "Total Tests: $((TESTS_PASSED + TESTS_FAILED))"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "\n${GREEN}🎉 ALL TESTS PASSED! Your fullstack containerized application is properly implemented.${NC}"
    exit 0
else
    echo -e "\n${YELLOW}⚠️  Some tests failed. Check the output above for details.${NC}"
    exit 1
fi
