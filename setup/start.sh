#!/bin/bash

tag=${1:-latest} 
make cleankeepdata
TAG="${tag}" docker-compose up -d
docker-compose logs -f
