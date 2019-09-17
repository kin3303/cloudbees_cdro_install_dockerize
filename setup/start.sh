#!/bin/bash

tag=${1:-latest} 
file=${2:-docker-compose.yaml} 
make cleankeepdata
TAG="${tag}" docker-compose up -d -f ${file}
docker-compose logs -f
ipAddress="$(dig @resolver1.opendns.com ANY myip.opendns.com +short)"
echo ""
echo "http://$ipAddress:1936/haproxy?stats"
echo "https://$ipAddress/flow"
echo "https://$ipAddress/commander"
