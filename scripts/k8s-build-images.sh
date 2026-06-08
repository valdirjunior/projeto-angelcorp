#!/bin/bash

set -e

CLUSTER_NAME="angelcorp"

echo "Buildando imagem do backend..."
docker build -t projeto-angelcorp-backend:latest ./backend

echo "Buildando imagem do frontend..."
docker build -t projeto-angelcorp-frontend:latest ./frontend

echo "Carregando imagem do backend no Kind..."
kind load docker-image projeto-angelcorp-backend:latest --name "$CLUSTER_NAME"

echo "Carregando imagem do frontend no Kind..."
kind load docker-image projeto-angelcorp-frontend:latest --name "$CLUSTER_NAME"

echo "Imagens carregadas no cluster $CLUSTER_NAME."