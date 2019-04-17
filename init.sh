#!/bin/bash

defaultRepo="https://github.com/kin3303/efdemo"

BRANCH=${1:-master} 
REMOTE_REPO=${2:-$defaultRepo}


localFolder="/Users/myname/dev/myfolder"
mkdir $BRANCH
cd $BRANCH

git init
git remote add -t $BRANCH -f origin $REMOTE_REPO
git checkout $BRANCH 

echo "alias efsetenv='bash ./setup/install.sh'" >> ~/.bashrc
echo "alias efstart='bash ./setup/start.sh'" >> ~/.bashrc
echo "alias efconfig='bash ./setup/config.sh'" >> ~/.bashrc
echo "alias efstop='bash ./setup/stop.sh'" >> ~/.bashrc
echo "alias efupload='bash ./setup/stop.sh'" >> ~/.bashrc

 
