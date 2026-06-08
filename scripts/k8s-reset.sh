#!/bin/bash

set -e

CLUSTER_NAME="angelcorp"

echo "Removendo cluster Kind ${CLUSTER_NAME}, se existir..."

kind delete cluster --name "$CLUSTER_NAME" || true

echo "Recriando ambiente Kubernetes do zero..."
./scripts/k8s-up.sh