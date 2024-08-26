#!/bin/bash

output_dir="../certs"

openssl genpkey -algorithm RSA -out "$output_dir"/ca.key -pkeyopt rsa_keygen_bits:2048
openssl req -new -x509 -key "$output_dir"/ca.key -out "$output_dir"/ca.crt -days 3650 -subj "/C=US/ST=California/L=San Francisco/O=MyOrganization/OU=MyUnit/CN=MyCA"
openssl genpkey -algorithm RSA -out "$output_dir"/server.key -pkeyopt rsa_keygen_bits:2048
openssl req -new -key "$output_dir"/server.key -out "$output_dir"/server.csr -config openssl.cnf
openssl genpkey -algorithm RSA -out "$output_dir"/server.key -pkeyopt rsa_keygen_bits:2048
openssl req -new -key "$output_dir"/server.key -out "$output_dir"/server.csr -config openssl.cnf
openssl x509 -req -in "$output_dir"/server.csr -CA "$output_dir"/ca.crt -CAkey "$output_dir"/ca.key -CAcreateserial -out "$output_dir"/server.crt -days 365 -extensions v3_req -extfile openssl.cnf
openssl genpkey -algorithm RSA -out "$output_dir"/client.key -pkeyopt rsa_keygen_bits:2048
openssl req -new -key "$output_dir"/client.key -out "$output_dir"/client.csr -config openssl.cnf
openssl x509 -req -in "$output_dir"/client.csr -CA "$output_dir"/ca.crt -CAkey "$output_dir"/ca.key -CAcreateserial -out "$output_dir"/client.crt -days 365 -extensions v3_req -extfile openssl.cnf
openssl verify -CAfile "$output_dir"/ca.crt "$output_dir"/server.crt "$output_dir"/client.crt

