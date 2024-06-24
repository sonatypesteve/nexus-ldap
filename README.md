# nexus-ldap
Docker compose and scripts for Nexus 3, Postgres and Openldap recipe.

This assumes you have Docker Compose installed. I use Docker Desktop and Ubuntu in WSL2.

* Edit [.env](.env) as needed.
* Edit [docker-compose.yaml](docker-compose.yaml) as needed.
* Edit [nexus-config.sh](scripts%2Fnexus-config.sh) as needed.
* `cd scripts`
*  `./nexus-config.sh`

How to do openldap queries using curl on the Nexus container:
* `docker exec -ti nexus-ldap /bin/bash`
* `curl -v -u "cn=admin,dc=nexus,dc=org" "ldap://openldap:1389/ou=users,dc=nexus,dc=org?hasSubordinates,objectClass?one?(objectClass=*)"`

```
sgoldsmith@sonatype:/mnt/d/IdeaProjects/nexus-ldap/scripts$ ./nexus-config.sh
[+] Running 6/6
 ✔ Volume "nexus-ldap_pgdata"         Created                                                          0.0s
 ✔ Volume "nexus-ldap_nexus-data"     Created                                                          0.0s
 ✔ Volume "nexus-ldap_openldap-data"  Created                                                          0.0s
 ✔ Container nexus-ldap-openldap-1    Started                                                          0.9s
 ✔ Container postgres                 Started                                                          0.6s
 ✔ Container nexus-ldap               Started                                                          0.9s
Waiting for Nexus to start.....
Nexus up
Changing admin password
Password changed
```
