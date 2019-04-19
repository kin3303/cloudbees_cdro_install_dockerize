#!/bin/bash

backupdir=/usr/share/elasticsearch/backup
snapshotdir=$backupdir/snapshot
rm -rf $snapshotdir
mkdir -p $snapshotdir
chown -R elasticsearch $snapshotdir
apt-get install curl

########################################################
# Add the required path.repo to elasticsearch yaml file
########################################################
cat >> /etc/elasticsearch/elasticsearch.yml << EOF
path.repo: ["$snapshotdir"]
EOF

########################################################
# Restart Elasticsearch
########################################################
./bin/elasticsearch

########################################################
# Add Repository
########################################################
URL_REQ=”https://insight:9200/_snapshot/my_backup”

curl -m 30 -XPUT $URL_REQ -H ‘Content-Type: application/json’ -d ‘{
 “type”: “fs”,
 “settings”: {
 “location”: “$snapshotdir”,
 “compress”: true
 }
}’

########################################################
# Create Snapshot
########################################################
backup_index=”.efinsight”
TIMESTAMP=`date +%Y%m%d`

curl  -k –X PUT \
   -E /usr/share/elasticsearch/data/conf/reporting/elasticsearch/admin.crtfull.pem \
   --key /usr/share/elasticsearch/data/conf/reporting/elasticsearch/admin.key.pem \
   “$URL_REQ/$TIMESTAMP?wait_for_completion=true” -H ‘Content-Type: application/json’ -d \
   ‘{ “indices”: “$backup_index”,  “ignore_unavailable”: true, “include_global_state”: false}’

########################################################
# Remove Previous Snapshot
########################################################
LIMIT=30
SNAPSHOTS=`curl -m 30 -s -XGET “$URL_REQ/_all” -H ‘Content-Type: application/json’ | jq “.snapshots[:-${LIMIT}][].snapshot”`

for SNAPSHOT in $SNAPSHOTS
do
 echo “Deleting snapshot: $SNAPSHOT”
 curl -m 30 -s -XDELETE ‘$URL_REQ/$SNAPSHOT?pretty’
done
echo “Done!”

########################################################
# Packaging Snapshot
########################################################
cd /tmp
tar -zcvf elasticsearch-backup.tar.gz $backupdir

#Restore Example
#cd /tmp
#tar xzvf elasticsearch-backup.tar.gz
#curl -k –X POST \
#   -E /usr/share/elasticsearch/data/conf/reporting/elasticsearch/admin.crtfull.pem \
#   --key /usr/share/elasticsearch/data/conf/reporting/elasticsearch/admin.key.pem \
#   “$URL_REQ/<snapshot_name>/_restore?wait_for_completion=true”


