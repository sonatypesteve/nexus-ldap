#!/bin/bash

# If the openldap container doesn't start on create it's probably because there's error(s)
# in generated output. Use BITNAMI_DEBUG=true in docker compose file to find out why.

# Source docker compose .env file
source ../.env

# Define the output file
output_file="../ldifs/init.ldif"

# Define groups and the number of users per group
groups=("IT:5" "Development:3" "Business:4" "HR:2" "Sales:6" "Support:3" "Administration:4")

# Base domain and organizational units
BASE_DN="$LDAP_ROOT"
groups_OU="ou=groups,$BASE_DN"
USERS_OU="ou=users,$BASE_DN"

# Initialize output file
cat <<EOF > "$output_file"
# LDIF generated for groups and assignments

dn: $BASE_DN
objectClass: top
objectClass: dcObject
objectClass: organization
o: Example Corp
dc: example

dn: ou=groups,$BASE_DN
objectClass: top
objectClass: organizationalUnit
ou: groups

dn: ou=users,$BASE_DN
objectClass: top
objectClass: organizationalUnit
ou: users

EOF

# Function to generate group LDIF entries with users
generate_group_ldif() {
  local group_name="$1"
  local user_count="$2"

  # Convert group name to lowercase for user prefix
  local user_prefix=$(echo "$group_name" | tr '[:upper:]' '[:lower:]')

  # Add users
  for ((i=1; i<=user_count; i++)); do
    printf -v user "${user_prefix}_user%02d" "$i"
    echo "dn: uid=$user,$USERS_OU" >> "$output_file"
    echo "objectClass: top" >> "$output_file"
    echo "objectClass: person" >> "$output_file"
    echo "objectClass: organizationalPerson" >> "$output_file"
    echo "objectClass: inetOrgPerson" >> "$output_file"
    echo "cn: $user""_cn" >> "$output_file"
    echo "mail: $user""@example.com" >> "$output_file"
    echo "sn: $user""_sn" >> "$output_file"
    echo "uid: $user" >> "$output_file"
    echo "userPassword: password" >> "$output_file"
    echo >> "$output_file"
  done

  echo "dn: cn=$group_name,$groups_OU" >> "$output_file"
  echo "objectClass: top" >> "$output_file"
  echo "objectClass: groupOfNames" >> "$output_file"
  echo "cn: $group_name" >> "$output_file"

  # Add users to the group
  for ((i=1; i<=user_count; i++)); do
    printf -v user "uid=${user_prefix}_user%02d" "$i"
    echo "member: $user,$USERS_OU" >> "$output_file"
  done

  # Add a separator for readability
  echo >> "$output_file"
}

# Iterate over groups and generate LDIF entries
for group in "${groups[@]}"; do
  group_name="${group%%:*}"
  user_count="${group##*:}"
  generate_group_ldif "$group_name" "$user_count"
done

# Print completion message
echo "LDIF file generated: $output_file"