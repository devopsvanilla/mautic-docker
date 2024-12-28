#!/usr/bin/env bash

mkdir -p ./cert

openssl genpkey -algorithm RSA -out ./cert/postfix_key.pem
#TODO criar prompt para os subject
openssl req -new -key ./cert/postfix_key.pem -out ./cert/postfix.csr -subj "/C=BR/ST=Sao Paulo/L=Peruibe/O=DevOpsVanilla/OU=DevOps/CN=postfix"
#TODO: criar processo para recriar o certificado a cada 30 dias
openssl x509 -req -days 365 -in ./cert/postfix.csr -signkey ./cert/postfix_key.pem -out ./cert/postfix_cert.pem


# Reasons for removing CSR:
# - CSR is only needed during certificate generation
# - Contains sensitive information
# - No longer needed after certificate is created
# - Security best practice to remove intermediate files
rm ./cert/postfix.csr

chmod 600 ./cert/postfix_key.pem
chmod 600 ./cert/postfix_cert.pem