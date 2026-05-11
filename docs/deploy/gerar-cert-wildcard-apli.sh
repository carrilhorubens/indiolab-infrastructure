#!/usr/bin/env bash
# =============================================================
# Gera cert wildcard self-signed *.apli.indiolab.com.br
# =============================================================
# Rede interna → Let's Encrypt não serve. Self-signed de 10 anos.
# Precisa instalar o CA (ca.crt) em todos os browsers e containers
# .NET que validam o cert do Keycloak via JWKS.
#
# Uso:
#   chmod +x gerar-cert-wildcard-apli.sh
#   sudo ./gerar-cert-wildcard-apli.sh
#
# Gera:
#   /etc/ssl/apli/ca.key            (CA private key)
#   /etc/ssl/apli/ca.crt            (CA cert — instalar em clients)
#   /etc/ssl/apli/wildcard.key      (server private key)
#   /etc/ssl/apli/wildcard.crt      (server cert assinado pela CA)
#   /etc/ssl/apli/wildcard.csr      (CSR — pode deletar depois)
# =============================================================
set -euo pipefail

DOMAIN="apli.indiolab.com.br"
DIR="/etc/ssl/apli"
DAYS_CA=3650
DAYS_CERT=3650
SUBDOMAINS=("erp" "crm" "chat" "admin" "auth")

if [[ $EUID -ne 0 ]]; then
  echo "Execute como root (sudo)." >&2
  exit 1
fi

mkdir -p "$DIR"
cd "$DIR"

# ── 1. CA (autoridade certificadora interna) ──
if [[ ! -f ca.crt ]]; then
  echo "[1/3] Gerando CA interna..."
  openssl genrsa -out ca.key 4096
  openssl req -x509 -new -nodes -key ca.key -sha256 -days "$DAYS_CA" \
    -subj "/C=BR/ST=SP/O=IndioLab/OU=IT/CN=IndioLab Internal CA" \
    -out ca.crt
else
  echo "[1/3] CA já existe em $DIR/ca.crt — reusando"
fi

# ── 2. SAN config (subjectAltName) ──
cat > san.cnf <<EOF
[req]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn
req_extensions     = req_ext

[dn]
C  = BR
ST = SP
O  = IndioLab
OU = IT
CN = *.${DOMAIN}

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = *.${DOMAIN}
DNS.2 = ${DOMAIN}
EOF

# ── 3. Server cert (wildcard) ──
echo "[2/3] Gerando wildcard cert *.${DOMAIN}..."
openssl genrsa -out wildcard.key 2048
openssl req -new -key wildcard.key -out wildcard.csr -config san.cnf

cat > v3.ext <<EOF
authorityKeyIdentifier = keyid,issuer
basicConstraints       = CA:FALSE
keyUsage               = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName         = @alt_names

[alt_names]
DNS.1 = *.${DOMAIN}
DNS.2 = ${DOMAIN}
EOF

openssl x509 -req -in wildcard.csr -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out wildcard.crt -days "$DAYS_CERT" -sha256 -extfile v3.ext

# ── 4. Permissões ──
echo "[3/3] Ajustando permissões..."
chmod 600 ca.key wildcard.key
chmod 644 ca.crt wildcard.crt
chown -R root:root "$DIR"

# ── 5. Trust na CA (Ubuntu/Debian) ──
cp ca.crt /usr/local/share/ca-certificates/indiolab-internal-ca.crt
update-ca-certificates

echo
echo "✔ Cert gerado em $DIR"
echo "  - wildcard.crt  → referenciar em ssl_certificate"
echo "  - wildcard.key  → referenciar em ssl_certificate_key"
echo
echo "Próximos passos:"
echo "  1. nginx -t && systemctl reload nginx"
echo "  2. Copiar $DIR/ca.crt para as máquinas dos usuários"
echo "     e instalar como Trusted Root CA (ou via GPO)"
echo "  3. Reconstruir containers .NET pra pegar a CA atualizada"
echo "     (update-ca-certificates roda no Dockerfile base debian/alpine)"
