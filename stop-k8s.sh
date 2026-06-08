#!/bin/bash

set -e

echo "Removendo recursos Kubernetes do AngelDesk..."
./scripts/k8s-down.sh
