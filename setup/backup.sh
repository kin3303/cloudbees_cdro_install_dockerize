#!/bin/bash

#mysql
docker exec -i $(docker ps |grep db_1|awk '{print $1}') sh -c ‘./tmp/scripts/backupdb.sh‘
 
#plugin

#logs

#repository-data

#workspace

#elasticSearch
 
