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
[+] Running 3/3
 ✔ Network nexus-ldap_default      Created                                                             0.0s
 ✔ Volume "nexus-ldap_nexus-data"  Created                                                             0.0s
 ✔ Container nexus-ldap            Started                                                             0.4s
Waiting for Nexus to start.....
Nexus up
Changing admin password
Password changed
License /mnt/c/Users/StevenGoldsmith/Documents/2023-sonatype-internal-rm-lc-fw-fwfa-adp-alp-iacp-5000apps-1000rm_users-1000lc_users-1000fw_users.lic installed
```
