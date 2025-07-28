# nexus-ldap
Docker compose and scripts for Nexus 3, Postgres and Openldap recipe.

This assumes you have Docker Compose installed. I use Docker Desktop and Ubuntu in WSL2.

* Edit [.env](.env) as needed.
* Edit docker-compose*.yaml files as needed.
* `cd scripts`
* `./certs.sh`
* `./dyngroups.sh`
* `./users.sh`
*  `./nexus-config.sh`
*  `./ldap-conn.sh`
* `./ldap-roles.sh'`

How to do openldap queries using curl on the OpenLDAP container:
* `docker exec -ti openldap /bin/bash`
* `curl -v -u "cn=admin,dc=example,dc=com" "ldap://openldap:1389/ou=users,dc=example,dc=com?hasSubordinates,objectClass?one?(objectClass=*)"`

How to access Postgres database:
* `docker exec -it postgres psql -U postgres -d postgres`

```
./nexus-config.sh
[+] Running 7/7
 ✔ Network nexus-ldap_default         Created                                                          0.0s
 ✔ Volume "nexus-ldap_openldap-data"  Created                                                          0.0s
 ✔ Volume "nexus-ldap_pgdata"         Created                                                          0.0s
 ✔ Volume "nexus-ldap_nexus-data"     Created                                                          0.0s
 ✔ Container openldap                 Started                                                          0.6s
 ✔ Container postgres                 Started                                                          0.5s
 ✔ Container nexus                    Started                                                          0.4s
Waiting for Nexus to start...
Nexus is up.
Changing admin's password...
admin's password changed successfully.
```
