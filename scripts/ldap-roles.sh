#!/bin/bash

# Automatically export all variables defined in ../.env to the environment
set -a
source ../.env
set +a

# Nexus server details
NEXUS_URL="$NEXUS_URL"
INPUT_FILE="dyngroups.txt"

# Read each line from the input file
while IFS= read -r line || [ -n "$line" ]; do
  # Clean up line endings and trim whitespace
  clean_line=$(echo "$line" | tr -d '\r' | xargs)
  [ -z "$clean_line" ] && continue  # Skip empty lines

  # Extract group name (first field)
  group=$(echo "$clean_line" | awk -F',' '{print $1}' | xargs | tr -d ',')

  # Extract privileges (fields 3 and onward), trim spaces
  privileges=$(echo "$clean_line" | awk -F',' '{for(i=3;i<=NF;i++) {gsub(/^[[:space:]]+|[[:space:]]+$/,"",$i); print $i}}')

  # Format privileges as a JSON array
  priv_array=$(echo "$privileges" | awk '{print "\"" $0 "\""}' | paste -sd, -)

  # Build JSON payload for the role
  payload=$(cat <<EOF
{
  "id": "$group",
  "name": "$group",
  "description": "Role mapped to LDAP group",
  "privileges": [
    $priv_array
  ],
  "roles": []
}
EOF
)

  # Send POST request to Nexus API to create the role
  response=$(curl -o /dev/null -s -w "%{http_code}\n" -u "$ADMIN_USER:$ADMIN_PASS" -X POST "$NEXUS_URL/service/rest/v1/security/roles" \
    -H "Content-Type: application/json" \
    -d "$payload")

  # Check response code and print result
  if [ "$response" == "200" ]; then
    echo "Role '$group' created successfully."
  else
    echo "Failed to create role '$group'. Response code: $response"
  fi
done < "$INPUT_FILE"
