#!/bin/bash
# Verifica se o caddyl4 está escutando com TLS na porta 8448

DOMAIN=${1:-yourdomain.com}
PORT=${2:-8448}

echo "🔍 Testando TLS em $DOMAIN:$PORT ..."

openssl s_client -connect "$DOMAIN:$PORT" -alpn h2 -brief < /dev/null 2>/dev/null | grep -q "SSL-Session"

if [ $? -eq 0 ]; then
  echo "✅ TLS ativo em $DOMAIN:$PORT"
  exit 0
else
  echo "❌ Falha ao conectar com TLS em $DOMAIN:$PORT"
  exit 1
fi
