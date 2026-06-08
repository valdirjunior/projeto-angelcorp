#!/bin/bash

set -e

echo "Parando AngelDesk..."
docker compose down

echo "Restaurando ambiente local..."
./scripts/restore-host.sh