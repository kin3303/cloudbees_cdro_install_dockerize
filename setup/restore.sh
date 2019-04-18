#!/bin/bash

#mysql
docker exec $(docker ps |grep db|awk '{print $1}') /bin/bash /tmp/scripts/restoredb.sh

#plugin

#logs

#repository-data

#workspace

#elasticSearch
 
