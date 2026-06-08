#!/bin/bash

set -e

echo "Iniciando AngelDesk no Kubernetes..."
./scripts/k8s-reset.sh

echo ""
echo "Ambiente Kubernetes criado."
echo "Agora rode:"
echo "./scripts/k8s-port-forward.sh"
