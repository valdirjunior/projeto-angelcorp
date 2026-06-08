#!/bin/bash

set -e

RUNTIME_DIR=".runtime"
NGINX_MARKER="$RUNTIME_DIR/local-nginx-was-active"

mkdir -p "$RUNTIME_DIR"

echo "Verificando Nginx local..."

if sudo ss -ltnp | grep ':80' | grep -q 'nginx'; then
  echo "Nginx local está usando a porta 80."
  echo "Registrando estado anterior..."
  touch "$NGINX_MARKER"

  echo "Parando Nginx local..."
  if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl stop nginx 2>/dev/null || sudo service nginx stop
  else
    sudo service nginx stop
  fi
else
  echo "Nginx local não está ativo na porta 80."
  rm -f "$NGINX_MARKER"
fi

echo "Porta 80 após preparação:"
sudo ss -ltnp | grep ':80' || echo "Porta 80 livre."