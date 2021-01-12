#!/bin/bash

# docker install
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
rm -rf ./get-docker.sh

# dcs install
curl -sL bit.ly/ralf_dcs -o ./dcs
chmod 755 ./dcs
mv ./dcs /usr/bin/dcs

# docker-compose install
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -sfT /usr/local/bin/docker-compose /usr/bin/docker-compose
