#!/bin/bash

set -e

echo "Verificando pods..."
kubectl get pods

echo ""
echo "Verificando services..."
kubectl get services

echo ""
echo "Verificando deployments..."
kubectl get deployments

echo ""
echo "Verificando PVC..."
kubectl get pvc

echo ""
echo "Verificando Job de inicialização do banco..."
kubectl get jobs

echo ""
echo "Para testar a API pelo frontend, o port-forward precisa estar ativo:"
echo "./scripts/k8s-port-forward.sh"
echo ""
echo "Com o port-forward ativo, rode:"
echo "curl http://localhost:8081/api/tickets"