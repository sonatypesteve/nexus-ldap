# nexus-ldap
Docker compose and scripts for Nexus 3, Postgres and Openldap recipe.

This assumes you have Docker Compose installed. I use Docker Desktop and Ubuntu in WSL2.

* Edit [.env](.env) as needed.
* Edit docker-compose*.yaml files as needed.
* Edit [nexus-config.sh](./scripts/nexus-config.sh) as needed.
* `cd scripts`
* `./certs.sh`
* `./generate-ldif.sh`
*  `./nexus-config.sh`

How to do openldap queries using curl on the Nexus container:
* `docker exec -ti nexus-ldap /bin/bash`
* `curl -v -u "cn=admin,dc=nexus,dc=org" "ldap://openldap:1389/ou=users,dc=nexus,dc=org?hasSubordinates,objectClass?one?(objectClass=*)"`

```
./nexus-config.sh
[+] Running 7/7
 ✔ Network nexus-ldap_default         Created                                                          0.0s
 ✔ Volume "nexus-ldap_openldap-data"  Created                                                          0.0s
 ✔ Volume "nexus-ldap_pgdata"         Created                                                          0.0s
 ✔ Volume "nexus-ldap_nexus-data"     Created                                                          0.0s
 ✔ Container postgres                 Started                                                          1.0s
 ✔ Container openldap                 Started                                                          1.0s
 ✔ Container nexus                    Started                                                          1.0s
Waiting for Nexus to start...
Nexus is up.
Changing admin's password...
admin's password changed successfully.
```
