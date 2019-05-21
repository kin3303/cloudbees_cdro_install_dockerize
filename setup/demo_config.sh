#!/bin/bash

docker exec $(docker ps |grep commanderserver_1|awk '{print $1}')  /tmp/scripts/set_demo_env.sh
