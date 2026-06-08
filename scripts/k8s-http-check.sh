#!/bin/bash

set -e

echo "Testando frontend Kubernetes em localhost:8081..."
curl -fsS http://localhost:8081 > /dev/null

echo "Frontend respondeu corretamente."

echo ""
echo "Testando API Kubernetes via /api..."
curl -fsS http://localhost:8081/api/tickets > /dev/null

echo "API respondeu corretamente."

echo ""
echo "Kubernetes HTTP OK."