#!/bin/bash

#mysql
docker exec $(docker ps |grep db_1|awk '{print $1}')  /tmp/scripts/backupdb.sh

#plugin

#logs

#repository-data

#workspace

#elasticSearch
 
