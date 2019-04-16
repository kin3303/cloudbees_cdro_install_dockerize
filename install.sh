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
cd $BRANCH/setup
./install.sh
