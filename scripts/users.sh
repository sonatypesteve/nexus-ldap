#!/bin/bash

# Input file containing group names (and counts, which are ignored)
INPUT="dyngroups.txt"
# Output LDIF file path
OUTPUT="../ldifs/00-root.ldif"

# Ensure the output directory exists
mkdir -p "$(dirname "$OUTPUT")"

# Start writing to the output file
{
# LDIF Header
cat <<EOF
dn: dc=example,dc=com
objectClass: dcObject
objectClass: organization
dc: example
o: example

dn: ou=users,dc=example,dc=com
objectClass: organizationalUnit
ou: users

dn: ou=groups,dc=example,dc=com
objectClass: organizationalUnit
ou: groups
EOF

# Initialize UID and GID counters
# Starting from 1100 as per your example
UID_COUNTER=1100
GID_COUNTER=1100

# Read dyngroups.txt and generate user entries
while IFS=',' read -r group_name num_users _; do
    # Trim whitespace and remove carriage return from num_users
    group_name=$(echo "$group_name" | xargs)
    num_users=$(echo "$num_users" | xargs | tr -d '\r') # Added tr -d '\r' here

    # Convert group name to lowercase for uid and cn
    lower_group_name=$(echo "$group_name" | tr '[:upper:]' '[:lower:]')

    # Skip empty lines if any
    if [ -z "$group_name" ]; then
        continue
    fi

    for i in $(seq 1 "$num_users"); do
        # Format user number with leading zeros if needed (e.g., user01, user10)
        # Using %01d means single digit, so 1, 2, ..., 9, 10, etc.
        user_num_formatted=$(printf "%d" "$i")

        user_cn="${group_name} User${user_num_formatted}"
        user_uid="${lower_group_name}user${user_num_formatted}"
        user_sn="${group_name:0:3}${user_num_formatted}" # First 3 chars of group + num

        cat <<EOF

dn: cn=${user_uid},ou=users,dc=example,dc=com
cn: ${user_cn}
cn: ${user_uid}
sn: ${user_sn}
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
employeeType: ${group_name}
uid: ${user_uid}
userPassword: password
uidNumber: ${UID_COUNTER}
gidNumber: ${GID_COUNTER}
homeDirectory: /home/${user_uid}
mail: ${user_uid}@example.com
EOF
        UID_COUNTER=$((UID_COUNTER + 1))
        GID_COUNTER=$((GID_COUNTER + 1))
    done
done < "$INPUT"

} > "$OUTPUT" # Redirect all output of the block to the OUTPUT file

echo "LDIF file generated: $OUTPUT"
