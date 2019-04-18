#!/bin/bash

docker exec $(docker ps |grep db_1|awk '{print $1}')  /tmp/scripts/backupdb.sh
 
