#!/bin/bash

#mysql
sudo docker exec -it $(docker ps |grep db_1|awk '{print $1}') /bin/bash /tmp/scripts/backupdb.sh

#plugin

#logs

#repository-data

#workspace

#elasticSearch
 