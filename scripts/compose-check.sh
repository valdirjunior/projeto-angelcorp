#!/bin/bash

set -e

echo "Verificando containers do Docker Compose..."
docker compose ps

echo ""
echo "Testando API via angeldesk.local..."
curl -fsS http://angeldesk.local/api/tickets > /dev/null

echo "API respondeu corretamente."

echo ""
echo "Testando frontend via angeldesk.local..."
curl -fsS http://angeldesk.local > /dev/null

echo "Frontend respondeu corretamente."

echo ""
echo "Docker Compose OK."