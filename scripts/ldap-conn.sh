#!/bin/bash

# Automatically export all variables defined in ../.env to the environment
set -a
source ../.env
set +a

# Nexus server URL
nexus_url="$NEXUS_URL"
# LDAP connection endpoint
add_ldap_connection_endpoint="$nexus_url/service/rest/v1/security/ldap"

# Function to add LDAP connection, returns HTTP response code
add_ldap_connection() {
  curl -o /dev/null -s -w "%{http_code}\n" -u ${ADMIN_USER}:${ADMIN_PASS} -X POST "$add_ldap_connection_endpoint" -H 'Content-Type: application/json' -d@ldap.json
}

# Call the function and store the response code
response="$(add_ldap_connection)"

# Check if the response code is 201 (Created)
if [ "$response" == "201" ]; then
  echo "LDAP connection created successfully."
else
  # Print failure message with response code
  echo "Failed to create LDAP connection $response"
fi
