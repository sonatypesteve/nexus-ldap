#!/bin/bash

# If the openldap container doesn't start on create it's probably because there's error(s)
# in generated output. Use BITNAMI_DEBUG=true in docker compose file to find out why.

# Source docker compose .env file
source ../.env

# Define the output file
output_file="../ldifs/init.ldif"

# Variables
IT_USERS=10
DEV_USERS=15
BUSINESS_USERS=20
HR_USERS=8
SALES_USERS=12
SUPPORT_USERS=10
ADMIN_USERS=5

# Functions
create_ldif_header() {
    echo "dn: $LDAP_ROOT"
    echo "objectClass: top"
    echo "objectClass: dcObject"
    echo "objectClass: organization"
    echo "o: Example Corp"
    echo "dc: example"
    echo ""
}

create_ou() {
    local ou=$1
    echo "dn: ou=$ou,$LDAP_ROOT"
    echo "objectClass: organizationalUnit"
    echo "ou: $ou"
    echo ""
}

create_user_entry() {
    local ou=$1
    local username=$2
    local cn="User $username"
    local sn="Last${username}"
    echo "dn: uid=$username,ou=$ou,$LDAP_ROOT"
    echo "objectClass: inetOrgPerson"
    echo "uid: $username"
    echo "cn: $cn"
    echo "sn: $sn"
    echo "mail: $username@example.com"
    echo ""
}

create_users() {
    local ou=$1
    local count=$2
    for i in $(seq 1 $count); do
        create_user_entry $ou "user$i"
    done
}

# Main Script
{
    create_ldif_header

    # Organizational Units
    create_ou "IT"
    create_ou "Development"
    create_ou "Business"
    create_ou "HR"
    create_ou "Sales"
    create_ou "Support"
    create_ou "Administration"

    # Users in IT
    create_users "IT" $IT_USERS

    # Users in Development
    create_users "Development" $DEV_USERS

    # Users in Business
    create_users "Business" $BUSINESS_USERS

    # Users in HR
    create_users "HR" $HR_USERS

    # Users in Sales
    create_users "Sales" $SALES_USERS

    # Users in Support
    create_users "Support" $SUPPORT_USERS

    # Users in Administration
    create_users "Administration" $ADMIN_USERS

} > "$output_file"

echo "LDIF file $output_file has been created."
