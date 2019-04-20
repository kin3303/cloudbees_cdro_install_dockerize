#!/bin/bash

backupdir=/usr/share/elasticsearch/backup
snapshotdir=$backupdir/snapshot

if [ ! -d "$snapshotdir" ]; then 
    echo "Creating backup directory : $snapshotdir"
    mkdir -p "$snapshotdir"
    chmod 777 $snapshotdir
    apt-get update
    apt-get install -y curl 
fi

rm -rf $snapshotdir/*

########################################################
# Add the required path.repo to elasticsearch yaml file
########################################################
if [ ! -f /opt/electriccloud/electriccommander/conf/reporting/elasticsearch/repository_ready ]; then
cat >> /opt/electriccloud/electriccommander/conf/reporting/elasticsearch/elasticsearch.yml << EOF
path.repo: ["$snapshotdir"]
EOF
touch /opt/electriccloud/electriccommander/conf/reporting/elasticsearch/repository_ready
fi

########################################################
# Add Repository
########################################################
URL_REQ=”https://localhost:9200/_snapshot/my_backup”

curl -m 30 -k –X PUT -E /usr/share/elasticsearch/data/conf/reporting/elasticsearch/admin.crtfull.pem --key /usr/share/elasticsearch/data/conf/reporting/elasticsearch/admin.key.pem -H ‘Content-Type:application/json’ \
-d ‘{“type”:“fs”,“settings”: {“location”:“$snapshotdir”,“compress”:true}}’

########################################################
# Create Snapshot
########################################################
echo “Creating snapshot...”

TIMESTAMP=`date +%Y%m%d`

curl  -k –XPUT -E /usr/share/elasticsearch/data/conf/reporting/elasticsearch/admin.crtfull.pem --key /usr/share/elasticsearch/data/conf/reporting/elasticsearch/admin.key.pem “$URL_REQ/$TIMESTAMP?wait_for_completion=true”
   
   #-H ‘Content-Type: application/json’ -d \
   #‘{ “indices”: “$backup_index”,  “ignore_unavailable”: true, “include_global_state”: false}’

########################################################
# Packaging Snapshot
########################################################
cd /tmp
tar -zcvf elasticsearch-backup.tar.gz $snapshotdir

#Restore Example
#cd /tmp
#tar xzvf elasticsearch-backup.tar.gz
#curl -k –X POST \
#   -E /usr/share/elasticsearch/data/conf/reporting/elasticsearch/admin.crtfull.pem \
#   --key /usr/share/elasticsearch/data/conf/reporting/elasticsearch/admin.key.pem \
#   “$URL_REQ/<snapshot_name>/_restore?wait_for_completion=true”


