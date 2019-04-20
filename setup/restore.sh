#!/bin/bash

backupFile=backup.tar.gz
if [ ! -f "$backupFile" ]; then 
    echo "Please check $backupFile file located in the source root."
    exit 1;
fi

restoreDir=data/db-data/backup/ecdb
rm -rf $restoreDir/*

###################################################################################################
# Stop server to restore data
###################################################################################################
#./setup/stop.sh

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
tar -zxvf $backupFile

rm -rf data/conf
rm -rf data/mysql
rm -rf data/workspace
rm -rf data/plugins
rm -rf data/repository-data
rm -rf data/insight-data

cp -r $restoreDir/conf data/conf
cp -r $restoreDir/mysql data/mysql  
cp -r $restoreDir/workspace data/workspace 
cp -r $restoreDir/plugins data/plugins 
cp -r $restoreDir/repository-data data/repository-data
cp -r $restoreDir/insight-data data/insight-data

###################################################################################################
# DB Restore
###################################################################################################
sudo docker exec -it $(docker ps |grep db_1|awk '{print $1}') /bin/bash /tmp/scripts/restoredb.sh

###################################################################################################
# Insight Restore
###################################################################################################
sudo docker exec -it $(docker ps |grep insight_1|awk '{print $1}') /bin/bash /tmp/scripts/restoreel.sh
