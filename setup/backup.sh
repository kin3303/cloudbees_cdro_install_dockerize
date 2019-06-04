#!/bin/bash

backupRoot=data/db-data/backup
rm -rf $backupRoot

###################################################################################################
# DB Backup
###################################################################################################
sudo docker exec -it $(docker ps |grep db_1|awk '{print $1}') /bin/bash /tmp/scripts/backupdb.sh

backupDir=$backupRoot/ecdb
if [ ! -d "$backupDir" ]; then
    echo "Backup Failed - There is no backup directory made by DB backup process";
    exit 1;
fi

###################################################################################################
# Elastic Search Backup
###################################################################################################
sudo docker exec -it $(docker ps |grep insight_1|awk '{print $1}') /bin/bash /tmp/scripts/backupel.sh
if [ ! -d "$backupDir/insight-data" ]; then
   mkdir -p "$backupDir/insight-data"
   echo "Create ElasticSearch Data Directory - $backupDir/insight-data"
fi
cp "data/insight-data/elasticsearch-backup.tar.gz" "$backupDir/insight-data"

###################################################################################################
# Data Backup
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
tar -zcvf backup.tar.gz $backupDir
rm -rf $backupRoot
