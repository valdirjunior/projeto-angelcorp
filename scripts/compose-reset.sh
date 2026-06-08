#!/bin/bash

set -e

echo "ATENÇÃO: removendo containers e volume do banco..."
docker compose down -v

echo "Restaurando ambiente local antes de subir novamente..."
./scripts/restore-host.sh

echo "Subindo aplicação limpa..."
./scripts/compose-up.sh