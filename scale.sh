#!/bin/bash

num=$1
if [ -z "${num}" ]; then
    echo 'Usage:'
    echo "$0 <scale_size>"
    exit 1
fi

docker-compose scale commanderserver=${num}
docker-compose logs -f
