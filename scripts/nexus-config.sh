#!/bin/bash

container_name="nexus-ldap"
password_file="sonatype-work/nexus3/admin.password"

docker-compose -f ../docker-compose.yaml up -d

# Check if the container is running
if [ "$(docker inspect "$container_name" --format '{{.State.Status}}')" = "running" ]; then
  # Wait for Nexus to start up
  max_attempts=20
  attempt=0
  printf 'Waiting for Nexus to start'
  while [[ "$attempt" -lt "$max_attempts" ]]; do
    printf '.'
    result=$(curl -o /dev/null -s -w "%{http_code}\n" -X GET http://localhost:8081/service/rest/v1/status)
    if [[ "$result" == "200" ]]; then
        printf "\nNexus up\n"
        break
    fi
    sleep 10
    ((attempt++))
  done

  # Check if password file exists
  if docker exec "$container_name" test -f "$password_file"; then
    # Change admin password to admin123
    printf "Changing admin password\n"
    password=$(docker exec "$container_name" cat "$password_file")
    # REST call to change admin password
    result=$(curl -o /dev/null -s -w "%{http_code}\n" -u admin:"$password" -X 'PUT' "http://localhost:8081/service/rest/v1/security/users/admin/change-password" -H 'accept: application/json' -H 'Content-Type: text/plain' -d 'admin123')
    if [[ "$result" == "204" ]]; then
      printf "Password changed\n"
    else
      printf "Password not changed\n"
    fi
  else
    printf "admin.password does not exist\n"
  fi
else
  printf "%s not running\n" "$container_name"
fi
