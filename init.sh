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
shopt -s expand_aliases
alias efsetenv='bash ./setup/install.sh'
alias efstart='bash ./setup/start.sh'" 
alias efconfig='bash ./setup/config.sh'
alias efstop='bash ./setup/stop.sh'" 
alias efupload='bash ./upload.sh'"

 
