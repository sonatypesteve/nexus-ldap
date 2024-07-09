#!/bin/bash

# If the openldap container doesn't start on create it's probably because there's error(s)
# in generated output. Use BITNAMI_DEBUG=true in docker compose file to find out why.

# Define the output file
output_file="../ldifs/init.ldif"

# Write the base structure to the LDIF file
cat <<EOL > $output_file
dn: dc=example,dc=com
objectClass: top
objectClass: dcObject
objectClass: organization
o: Example Corp
dc: example

dn: ou=People,dc=example,dc=com
objectClass: organizationalUnit
ou: People

dn: ou=Groups,dc=example,dc=com
objectClass: organizationalUnit
ou: Groups

dn: ou=Developers,dc=example,dc=com
objectClass: organizationalUnit
ou: Developers

dn: ou=HR,dc=example,dc=com
objectClass: organizationalUnit
ou: HR

dn: ou=IT,dc=example,dc=com
objectClass: organizationalUnit
ou: IT
EOL

# Add users to the People organizational unit
for i in {1..10}; do
  cat <<EOL >> $output_file

dn: uid=user$i,ou=People,dc=example,dc=com
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

dn: uid=dev$i,ou=Developers,dc=example,dc=com
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

dn: uid=hr$i,ou=HR,dc=example,dc=com
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

dn: uid=it$i,ou=IT,dc=example,dc=com
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

dn: cn=developers,ou=Groups,dc=example,dc=com
objectClass: groupOfUniqueNames
cn: developers
uniqueMember: uid=dev1,ou=Developers,dc=example,dc=com
uniqueMember: uid=dev2,ou=Developers,dc=example,dc=com
uniqueMember: uid=dev3,ou=Developers,dc=example,dc=com
uniqueMember: uid=dev4,ou=Developers,dc=example,dc=com
uniqueMember: uid=dev5,ou=Developers,dc=example,dc=com

dn: cn=hr,ou=Groups,dc=example,dc=com
objectClass: groupOfUniqueNames
cn: hr
uniqueMember: uid=hr1,ou=HR,dc=example,dc=com
uniqueMember: uid=hr2,ou=HR,dc=example,dc=com
uniqueMember: uid=hr3,ou=HR,dc=example,dc=com

dn: cn=it,ou=Groups,dc=example,dc=com
objectClass: groupOfUniqueNames
cn: it
uniqueMember: uid=it1,ou=IT,dc=example,dc=com
uniqueMember: uid=it2,ou=IT,dc=example,dc=com
uniqueMember: uid=it3,ou=IT,dc=example,dc=com
uniqueMember: uid=it4,ou=IT,dc=example,dc=com
EOL

echo "LDIF file $output_file created successfully."
