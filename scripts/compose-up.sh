#!/bin/bash

set -e

echo "Preparando ambiente local..."
./scripts/prepare-host.sh

echo "Subindo AngelDesk com Docker Compose..."
docker compose up --build -d

echo ""
echo "Status dos containers:"
docker compose ps

echo ""
echo "Aplicação disponível em:"
echo "http://angeldesk.local"

echo ""
echo "API disponível em:"
echo "http://angeldesk.local/api/tickets"