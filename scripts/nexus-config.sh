#!/bin/bash

container_name="nexus"
password_file="sonatype-work/nexus3/admin.password"
nexus_url="http://localhost:8081"
status_endpoint="$nexus_url/service/rest/v1/status"
change_password_endpoint="$nexus_url/service/rest/v1/security/users/admin/change-password"

# User and password variables
user="admin" # Change this to the desired username
new_password="admin123" # Change this to the desired new password

# Function to check Nexus status
check_nexus_status() {
  curl -o /dev/null -s -w "%{http_code}\n" -X GET "$status_endpoint"
}

# Function to change Nexus admin password
change_admin_password() {
  curl -o /dev/null -s -w "%{http_code}\n" -u ${user}:"$1" -X PUT "$change_password_endpoint" -H 'accept: application/json' -H 'Content-Type: text/plain' -d "${new_password}"
}

# Start containers
docker-compose -f ../docker-compose-openldap.yaml -f ../docker-compose-postgres.yaml -f ../docker-compose-nexus.yaml up -d

# Check if Nexus container is running
if [ "$(docker inspect "$container_name" --format '{{.State.Status}}')" = "running" ]; then
  # Wait for Nexus to start
  max_attempts=20
  attempt=0
  echo 'Waiting for Nexus to start...'
  while [ "$attempt" -lt "$max_attempts" ]; do
    if [ "$(check_nexus_status)" == "200" ]; then
      echo "Nexus is up."
      break
    fi
    sleep 10
    ((attempt++))
  done

  if [ "$attempt" -eq "$max_attempts" ]; then
    echo "Nexus did not start in time."
    exit 1
  fi

  # Check if the admin password file exists
  if docker exec "$container_name" test -f "$password_file"; then
    # Change admin password
    echo "Changing ${user}'s password..."
    password=$(docker exec "$container_name" cat "$password_file")
    if [ "$(change_admin_password "$password")" == "204" ]; then
      echo "${user}'s password changed successfully."
    else
      echo "Failed to change ${user}'s password."
    fi
  else
    echo "Admin password file does not exist."
  fi
else
  echo "$container_name is not running."
fi
