#!/bin/bash

#mysql
docker exec $(docker ps |grep db|awk '{print $1}')  /tmp/scripts/backupdb.sh

#plugin

#logs

#repository-data

#workspace

#elasticSearch
 
