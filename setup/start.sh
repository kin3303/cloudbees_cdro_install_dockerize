#!/bin/bash

tag=${1:-latest} 
file=${2:-docker-compose.yaml} 
make cleankeepdata
TAG="${tag}" docker-compose -f ${file} up -d
docker-compose logs -f
ipAddress="$(dig @resolver1.opendns.com ANY myip.opendns.com +short)"
echo ""
echo "https://$ipAddress/flow"
echo "https://$ipAddress/commander"
