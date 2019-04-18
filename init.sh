#!/bin/bash

# CHECKOUT SOURCES
defaultRepo="https://github.com/kin3303/efdemo"

BRANCH=${1:-master} 
REMOTE_REPO=${2:-$defaultRepo}

mkdir $BRANCH
cd $BRANCH

git init
git remote add -t $BRANCH -f origin $REMOTE_REPO
git checkout $BRANCH 

# MAKE ALIAS
echo -e "alias efsetenv='bash ./setup/install.sh'" >> ~/.bashrc
echo -e "alias efstart='bash ./setup/start.sh'" >> ~/.bashrc
echo -e "alias efconfig='bash ./setup/config.sh'" >> ~/.bashrc
echo -e "alias efstop='bash ./setup/stop.sh'" >> ~/.bashrc
echo -e "alias efscale='bash ./setup/scale.sh'" >> ~/.bashrc
echo -e "alias efupload='bash ./upload.sh'" >> ~/.bashrc
echo -e "alias efbackup='bash ./backup.sh'" >> ~/.bashrc
echo -e "alias efrestore='bash ./restore.sh'" >> ~/.bashrc
