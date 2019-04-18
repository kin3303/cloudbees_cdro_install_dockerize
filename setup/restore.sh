#!/bin/bash

###################################################################################################
# DB Restore
###################################################################################################
sudo docker exec -it $(docker ps |grep db_1|awk '{print $1}') /bin/bash /tmp/scripts/restoredb.sh

restoreDir=data/db-data/backup/ecdb

rm -rf $restoreDir/*


unzip 'abc*.zip'
if [ !-d "backup.tar.xz" ]; then
   echo "Restore Failed - There is no backup.tar.xz";
   exit 1;
fi

if [ !-d "$restoreDir" ]; then
    echo "Backup Failed - There is no backup directory made by DB backup process";
    exit 1;
fi

###################################################################################################
# Data Restore
#    Configuration Files
#       <DATADIR>/conf  :  Configuration files for the Server and  Artifact Repository
#       <DATADIR>/mysql/mysql.cnf  : Configuration file for MYSQL
#       <DATADIR>/apache/conf  : Configuration files for the Web Server => SKIPED 
#    Workspace Directories
#       <DATADIR>/workspace
#    Plugins
#       <DATADIR>/plugins
#    Artifact
#       <DATADIR>/repository-data
###################################################################################################
cp -r data/conf $backupDir
cp -r data/mysql  $backupDir
cp -r data/workspace $backupDir
cp -r data/plugins $backupDir
cp -r data/repository-data $backupDir
 
###################################################################################################
# Packaging
###################################################################################################
date=$(date +%F)

tar cvfj backup.tar.xz  $backupDir
tar tvf backup.tar.xz
