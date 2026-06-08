#!/bin/bash

set -e

echo "Removendo recursos da aplicação no Kubernetes..."

kubectl delete -f k8s/frontend-service.yaml --ignore-not-found=true
kubectl delete -f k8s/frontend-deployment.yaml --ignore-not-found=true

kubectl delete -f k8s/backend-service.yaml --ignore-not-found=true
kubectl delete -f k8s/backend-deployment.yaml --ignore-not-found=true
kubectl delete -f k8s/backend-configmap.yaml --ignore-not-found=true

kubectl delete job db-init-job --ignore-not-found=true

kubectl delete -f k8s/db-service.yaml --ignore-not-found=true
kubectl delete -f k8s/db-deployment.yaml --ignore-not-found=true
kubectl delete -f k8s/db-pvc.yaml --ignore-not-found=true
kubectl delete -f k8s/db-pv.yaml --ignore-not-found=true
kubectl delete -f k8s/db-secret.yaml --ignore-not-found=true

echo "Recursos removidos."