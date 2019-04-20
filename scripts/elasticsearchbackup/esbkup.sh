#!/bin/bash

backupdir=/usr/share/elasticsearch/backup
snapshotdir=$backupdir/snapshot/

if [ ! -d "$snapshotdir" ]; then 
    echo "Creating backup directory : $snapshotdir"
    mkdir -p "$snapshotdir"
    chmod 777 $snapshotdir
    apt-get update
    apt-get install -y curl
    apt-get install -y jq
fi

rm -rf $snapshotdir/*

########################################################
# Add the required path.repo to elasticsearch yaml file
########################################################
if [ ! -f /opt/electriccloud/electriccommander/conf/reporting/elasticsearch/repository_ready ]; then
cat >> /opt/electriccloud/electriccommander/conf/reporting/elasticsearch/elasticsearch.yml << EOF
path.repo: ["$snapshotdir"]
network.host: 0.0.0.0
EOF
touch /opt/electriccloud/electriccommander/conf/reporting/elasticsearch/repository_ready
fi

/etc/init.d/commanderElasticsearch restart

########################################################
# Add Repository
########################################################
curl -XPUT 'http://localhost:9200/_snapshot/my_backup' -d '{"type":"fs","settings":{"location": "/usr/share/elasticsearch/backup/snapshot","compress": true}}'

########################################################
# Create Snapshot
########################################################
echo Creating snapshot...

SNAPSHOT=`date +%Y%m%d-%H%M%S`
curl -XPUT "http://localhost:9200/_snapshot/my_backup/$SNAPSHOT?wait_for_completion=true"  

########################################################
# Cleanup Old Snapshot
########################################################

# The amount of snapshots we want to keep.
LIMIT=30

# Name of our snapshot repository
REPO=my_backup

# Get a list of snapshots that we want to delete
SNAPSHOTS=`curl -s -XGET "http://localhost:9200/_snapshot/$REPO/_all"  | jq -r ".snapshots[:-${LIMIT}][].snapshot"`

# Loop over the results and delete each snapshot
for SNAPSHOT in $SNAPSHOTS
do
 echo "Deleting snapshot: $SNAPSHOT"
 curl -s -XDELETE "http://localhost:9200/_snapshot/$REPO/$SNAPSHOT?pretty"
done
echo "Done!"

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


