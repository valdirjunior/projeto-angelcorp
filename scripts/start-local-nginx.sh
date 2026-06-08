#!/bin/bash

echo "Reativando Nginx local..."

if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl start nginx 2>/dev/null || sudo service nginx start
else
  sudo service nginx start
fi

echo "Status da porta 80:"
sudo ss -ltnp | grep ':80' || true