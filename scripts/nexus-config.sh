#!/bin/bash

CONTAINER_NAME="nexus-ldap-nexus-1"
PASSWORD_FILE="sonatype-work/nexus3/admin.password"

# Check if the container is running
if [ "$(docker inspect "$CONTAINER_NAME" --format '{{.State.Status}}')" = "running" ]; then
  # Check if password file exists
  if docker exec "$CONTAINER_NAME" test -f "$PASSWORD_FILE"; then
    # Change admin password to admin123
    echo "Changing admin password"
    password=$(docker exec "$CONTAINER_NAME" cat "$PASSWORD_FILE")
    # REST call to change admin password
    curl -v -u admin:"$password" -X 'PUT' \
    "http://localhost:8081/service/rest/v1/security/users/admin/change-password" \
    -H 'accept: application/json' \
    -H 'Content-Type: text/plain' \
    -d 'admin123'
  else
    echo "admin.password does not exist"
  fi
else
  echo "$CONTAINER_NAME not running"
fi
