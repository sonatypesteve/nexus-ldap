# nexus-ldap
Docker compose for Nexus 3 and ldap

This assumes you have Docker Compose installed. I use Docker Desktop and Ubuntu in WSL2.

^ Edit [.env](.env) as needed.
* Edit [docker-compose.yaml](docker-compose.yaml) as needed.
* Edit [nexus-config.sh](scripts%2Fnexus-config.sh) as needed.
* `cd scripts`
*  `./nexus-config.sh`

```
sgoldsmith@sonatype:/mnt/d/IdeaProjects/nexus-ldap/scripts$ ./nexus-config.sh
[+] Running 5/5
 ✔ Network nexus-ldap_default      Created                                                             0.0s
 ✔ Volume "nexus-ldap_nexus-data"  Created                                                             0.0s
 ✔ Volume "nexus-ldap_pgdata"      Created                                                             0.0s
 ✔ Container postgres              Started                                                             0.6s
 ✔ Container nexus-ldap            Started                                                             0.6s
Waiting for Nexus to start.....
Nexus up
Changing admin password
Password changed
```
