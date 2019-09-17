#!/bin/bash

docker exec $(docker ps |grep commanderserver|awk '{print $1}')  /tmp/scripts/set_demo_env.sh

docker exec $(docker ps |grep db|awk '{print $1}')  /tmp/scripts/initialize_db.sh
