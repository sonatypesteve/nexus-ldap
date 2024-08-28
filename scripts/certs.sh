#!/bin/bash

# Set the output directory for the certificates
output_dir="../certs"

# Generate the CA private key
openssl genpkey -algorithm RSA -out "$output_dir"/ca.key -pkeyopt rsa_keygen_bits:2048

# Generate the CA certificate
openssl req -new -x509 -key "$output_dir"/ca.key -out "$output_dir"/ca.crt -days 3650 -subj "/C=US/ST=California/L=San Francisco/O=MyOrganization/OU=MyUnit/CN=MyCA"

# Generate the server private key
openssl genpkey -algorithm RSA -out "$output_dir"/server.key -pkeyopt rsa_keygen_bits:2048

# Generate the server certificate signing request (CSR)
openssl req -new -key "$output_dir"/server.key -out "$output_dir"/server.csr -config openssl.cnf

# Generate the server private key again (duplicate step, can be removed)
openssl genpkey -algorithm RSA -out "$output_dir"/server.key -pkeyopt rsa_keygen_bits:2048

# Generate the server certificate signing request (CSR) again (duplicate step, can be removed)
openssl req -new -key "$output_dir"/server.key -out "$output_dir"/server.csr -config openssl.cnf

# Generate the server certificate signed by the CA
openssl x509 -req -in "$output_dir"/server.csr -CA "$output_dir"/ca.crt -CAkey "$output_dir"/ca.key -CAcreateserial -out "$output_dir"/server.crt -days 365 -extensions v3_req -extfile openssl.cnf

# Generate the client private key
openssl genpkey -algorithm RSA -out "$output_dir"/client.key -pkeyopt rsa_keygen_bits:2048

# Generate the client certificate signing request (CSR)
openssl req -new -key "$output_dir"/client.key -out "$output_dir"/client.csr -config openssl.cnf

# Generate the client certificate signed by the CA
openssl x509 -req -in "$output_dir"/client.csr -CA "$output_dir"/ca.crt -CAkey "$output_dir"/ca.key -CAcreateserial -out "$output_dir"/client.crt -days 365 -extensions v3_req -extfile openssl.cnf

# Verify the server and client certificates against the CA certificate
openssl verify -CAfile "$output_dir"/ca.crt "$output_dir"/server.crt "$output_dir"/client.crt
