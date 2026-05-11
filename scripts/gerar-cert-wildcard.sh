#!/usr/bin/env bash
# Gera cert wildcard self-signed para *.dev.indiolab.com.br
# Saída: /etc/nginx/ssl/dev.indiolab.com.br.{crt,key}
#
# Uso (no servidor): sudo ./deploy/scripts/gerar-cert-wildcard.sh
set -euo pipefail

SSL_DIR=/etc/nginx/ssl
DOMAIN=dev.indiolab.com.br

echo "==> criando $SSL_DIR (se necessário)"
mkdir -p "$SSL_DIR"

echo "==> gerando chave privada + cert (validade 10 anos)"
openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout "$SSL_DIR/$DOMAIN.key" \
  -out    "$SSL_DIR/$DOMAIN.crt" \
  -days 3650 \
  -subj "/C=BR/ST=SP/L=SaoPaulo/O=IndioLab/CN=*.$DOMAIN" \
  -addext "subjectAltName=DNS:$DOMAIN,DNS:*.$DOMAIN,DNS:erp.$DOMAIN,DNS:crm.$DOMAIN,DNS:chat.$DOMAIN,DNS:admin.$DOMAIN,DNS:auth.$DOMAIN,DNS:n8n.$DOMAIN"

chmod 644 "$SSL_DIR/$DOMAIN.crt"
chmod 600 "$SSL_DIR/$DOMAIN.key"

echo "==> verificando"
openssl x509 -in "$SSL_DIR/$DOMAIN.crt" -noout -subject -issuer -dates -ext subjectAltName

echo ""
echo "✓ cert wildcard gerado em $SSL_DIR/$DOMAIN.{crt,key}"
echo "  Distribua o .crt para máquinas dos usuários (instalar como CA confiável)"
