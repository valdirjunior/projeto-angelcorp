#!/bin/bash

set -e

CLUSTER_NAME="angelcorp"

echo "Verificando cluster Kind..."

if ! kind get clusters | grep -q "^${CLUSTER_NAME}$"; then
  echo "Cluster ${CLUSTER_NAME} não encontrado. Criando cluster..."
  kind create cluster --name "$CLUSTER_NAME"
else
  echo "Cluster ${CLUSTER_NAME} já existe."
fi

echo "Usando contexto do cluster..."
kubectl cluster-info

echo "Buildando e carregando imagens no cluster..."
./scripts/k8s-build-images.sh

echo "Aplicando recursos do banco..."
kubectl apply -f k8s/db-secret.yaml
kubectl apply -f k8s/db-pv.yaml
kubectl apply -f k8s/db-pvc.yaml
kubectl apply -f k8s/db-deployment.yaml
kubectl apply -f k8s/db-service.yaml

echo "Aguardando PostgreSQL ficar disponível..."
kubectl rollout status deployment/postgres --timeout=180s

echo "Executando Job de inicialização do banco..."
kubectl delete job db-init-job --ignore-not-found=true
kubectl apply -f k8s/db-init-job.yaml
kubectl wait --for=condition=complete job/db-init-job --timeout=120s

echo "Aplicando backend..."
kubectl apply -f k8s/backend-configmap.yaml
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/backend-service.yaml

echo "Aguardando backend ficar disponível..."
kubectl rollout status deployment/backend --timeout=180s

echo "Aplicando frontend..."
kubectl apply -f k8s/frontend-deployment.yaml
kubectl apply -f k8s/frontend-service.yaml

echo "Aguardando frontend ficar disponível..."
kubectl rollout status deployment/frontend --timeout=180s

echo ""
echo "Recursos criados:"
kubectl get pods
echo ""
kubectl get services

echo ""
echo "Kubernetes pronto."
echo "Para acessar a aplicação, rode em outro terminal:"
echo "./scripts/k8s-port-forward.sh"