#!/bin/bash

tag=${1:-latest} 
make cleankeepdata
TAG="${tag}" docker-compose up -d
docker-compose logs -f
ipAddress="$(dig @resolver1.opendns.com ANY myip.opendns.com +short)"
echo "http://$ipAddress:1936/haproxy?stats"
