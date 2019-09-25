#!/bin/bash

docker exec $(docker ps |grep mysql|awk '{print $1}')  /tmp/scripts/dbtuning.sh
 