#!/bin/bash

set -e

RUNTIME_DIR=".runtime"
NGINX_MARKER="$RUNTIME_DIR/local-nginx-was-active"

if [ -f "$NGINX_MARKER" ]; then
  echo "O Nginx local estava ativo antes da execução."
  echo "Reativando Nginx local..."

  if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl start nginx 2>/dev/null || sudo service nginx start
  else
    sudo service nginx start
  fi

  rm -f "$NGINX_MARKER"

  echo "Nginx local reativado."
else
  echo "Nginx local não estava ativo antes. Nada a restaurar."
fi