#!/bin/bash

set -e

echo "Iniciando port-forward do frontend..."
echo "A aplicação ficará disponível em:"
echo "http://localhost:8081"
echo ""
echo "Pressione CTRL+C para encerrar."

kubectl port-forward service/frontend-service 8081:80