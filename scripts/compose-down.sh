#!/bin/bash

set -e

echo "Parando containers do AngelDesk..."
docker compose down

echo ""
echo "Restaurando ambiente local..."
./scripts/restore-host.sh

echo ""
echo "Aplicação parada."