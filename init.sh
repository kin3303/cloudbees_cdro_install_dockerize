#!/bin/bash

# CHECKOUT SOURCES
defaultRepo="https://github.com/kin3303/CBF_DEMO"

BRANCH=${1:-master} 
REMOTE_REPO=${2:-$defaultRepo}

mkdir $BRANCH
cd $BRANCH

apt-get install -y git
git init
git remote add -t $BRANCH -f origin $REMOTE_REPO
git checkout $BRANCH 

chmod 777 data/*

# MAKE ALIAS
echo -e "alias cbfInstallPackage='bash ./setup/install.sh'" >> ~/.bashrc
echo -e "alias cbfInstallCBF='bash ./setup/start.sh'" >> ~/.bashrc
echo -e "alias cbfConfigEnv='bash ./setup/config.sh'" >> ~/.bashrc
echo -e "alias cbfSetDemo='bash ./setup/demo_config.sh'" >> ~/.bashrc  

# Because SonarQube & DevOps Insight uses an embedded Elasticsearch,
# make sure that your Docker host configuration complies with the Elasticsearch production mode requirements and -
# File Descriptors configuration.
sysctl -w vm.max_map_count=262144 
sysctl -w fs.file-max=65536
ulimit -n 65536
ulimit -u 4096  
