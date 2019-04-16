#!/bin/bash

tag=$1
if [ -z "${tag}" ]; then
    echo 'Usage:'
    echo "$0 <tag>"
    exit 1
fi

#export TAG="${tag}"
make cleankeepdata
TAG="${tag}" docker-compose up -d
docker-compose logs -f
