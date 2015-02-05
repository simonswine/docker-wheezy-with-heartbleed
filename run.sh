#!/bin/sh

BASE_PATH="/etc/nginx/cert"
SSL_KEY="${BASE_PATH}.key"
SSL_CRT="${BASE_PATH}.pem"
SSL_REQ="${BASE_PATH}.csr"

# Check if key exists
if [ ! -d ${SSL_KEY} ]; then
    openssl genrsa -out ${SSL_KEY} 4096
fi
chmod -c 400 ${SSL_KEY}

# Check if certificate exists
if [ ! -d ${SSL_CRT} ]; then
    # Generate CSR
    openssl req -new -sha256 -subj "/C=DE/O=Swine.de/CN=heartbleeder" -key ${SSL_KEY} -out ${SSL_REQ}
    # Sign CRT
    openssl x509 -req -days 365 -sha256 -in ${SSL_REQ} -signkey ${SSL_KEY} -out ${SSL_CRT}
fi

exec /usr/sbin/nginx -g "daemon off;"
