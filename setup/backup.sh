#!/bin/bash

#mysql db backup
docker exec $(docker ps |grep db_1|awk '{print $1}')  /tmp/scripts/backupdb.sh

#plugin directory backup

#logs backup


#repository-data backup
 
