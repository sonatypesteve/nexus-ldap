#!/bin/bash

# If the openldap container doesn't start on create it's probably because there's error(s)
# in generated output. Use BITNAMI_DEBUG=true in docker compose file to find out why.

# Source docker compose .env file
source ../.env

# Define the output file
output_file="../ldifs/init.ldif"

# Write the base structure to the LDIF file
cat <<EOL > $output_file
dn: $LDAP_ROOT
objectClass: top
objectClass: dcObject
objectClass: organization
o: Example Organization
dc: example

dn: ou=people,$LDAP_ROOT
objectClass: top
objectClass: organizationalUnit
ou: people

dn: ou=groups,$LDAP_ROOT
objectClass: top
objectClass: organizationalUnit
ou: groups
EOL

# Add the admin user to the People organizational unit
cat <<EOL >> $output_file

dn: uid=admin,ou=people,$LDAP_ROOT
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
cn: Admin User
sn: User
uid: admin
mail: admin@example.com
userPassword: admin123
EOL

# Add general users to the People organizational unit
for i in {1..10}; do
  cat <<EOL >> $output_file

dn: uid=user$i,ou=people,$LDAP_ROOT
objectClass: inetOrgPerson
uid: user$i
sn: User
cn: User $i
mail: user$i@example.com
userPassword: password
EOL
done

# Add users to the Developers organizational unit
for i in {1..5}; do
  cat <<EOL >> $output_file

dn: uid=dev$i,ou=people,$LDAP_ROOT
objectClass: inetOrgPerson
uid: dev$i
sn: Developer
cn: Developer $i
mail: dev$i@example.com
userPassword: password
EOL
done

# Add users to the HR organizational unit
for i in {1..3}; do
  cat <<EOL >> $output_file

dn: uid=hr$i,ou=people,$LDAP_ROOT
objectClass: inetOrgPerson
uid: hr$i
sn: HR
cn: HR $i
mail: hr$i@example.com
userPassword: password
EOL
done

# Add users to the IT organizational unit
for i in {1..4}; do
  cat <<EOL >> $output_file

dn: uid=it$i,ou=people,$LDAP_ROOT
objectClass: inetOrgPerson
uid: it$i
sn: IT
cn: IT $i
mail: it$i@example.com
userPassword: password
EOL
done

# Add groups to the Groups organizational unit
cat <<EOL >> $output_file

dn: cn=developers,ou=groups,$LDAP_ROOT
objectClass: groupOfUniqueNames
cn: developers
uniqueMember: uid=dev1,ou=people,$LDAP_ROOT
uniqueMember: uid=dev2,ou=people,$LDAP_ROOT
uniqueMember: uid=dev3,ou=people,$LDAP_ROOT
uniqueMember: uid=dev4,ou=people,$LDAP_ROOT
uniqueMember: uid=dev5,ou=people,$LDAP_ROOT

dn: cn=hr,ou=groups,$LDAP_ROOT
objectClass: groupOfUniqueNames
cn: hr
uniqueMember: uid=hr1,ou=people,$LDAP_ROOT
uniqueMember: uid=hr2,ou=people,$LDAP_ROOT
uniqueMember: uid=hr3,ou=people,$LDAP_ROOT

dn: cn=it,ou=groups,$LDAP_ROOT
objectClass: groupOfUniqueNames
cn: it
uniqueMember: uid=it1,ou=people,$LDAP_ROOT
uniqueMember: uid=it2,ou=people,$LDAP_ROOT
uniqueMember: uid=it3,ou=people,$LDAP_ROOT
uniqueMember: uid=it4,ou=people,$LDAP_ROOT
EOL

echo "LDIF file $output_file created successfully."
