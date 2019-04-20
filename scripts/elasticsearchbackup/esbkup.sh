#!/bin/bash

backupdir=/usr/share/elasticsearch/backup
snapshotdir=$backupdir/snapshot/

if [ ! -d "$snapshotdir" ]; then 
    echo "Creating backup directory : $snapshotdir"
    mkdir -p "$snapshotdir"
    chmod 777 $snapshotdir
else
    rm -rf $snapshotdir/*
fi

########################################################
# Add the required path.repo to elasticsearch yaml file
########################################################
if [ ! -f /opt/electriccloud/electriccommander/conf/reporting/elasticsearch/repository_ready ]; then
cat >> /opt/electriccloud/electriccommander/conf/reporting/elasticsearch/elasticsearch.yml << EOF
path.repo: ["$snapshotdir"]
EOF
touch /opt/electriccloud/electriccommander/conf/reporting/elasticsearch/repository_ready
fi 

/etc/init.d/commanderElasticsearch restart 

########################################################
# Add Repository
########################################################
echo "Adding Repository"
outputAR="$(curl -XPUT 'http://localhost:9200/_snapshot/my_backup' -d '{"type":"fs","settings":{"location": "/usr/share/elasticsearch/backup/snapshot","compress": true}}')"
echo "Done"

########################################################
# Create Snapshot
########################################################
echo "Creating snapshot..."
SNAPSHOT="insight"
outputCS="$(curl -XPUT "http://localhost:9200/_snapshot/my_backup/$SNAPSHOT?wait_for_completion=true")"
echo "Done-$outputCS"

########################################################
# Cleanup Old Snapshot
########################################################
echo "Deleting old snapshot..."

LIMIT=1
REPO=my_backup
SNAPSHOTS=`curl -s -XGET "http://localhost:9200/_snapshot/$REPO/_all"  | jq -r ".snapshots[:-${LIMIT}][].snapshot"`

# Loop over the results and delete each snapshot
for SNAPSHOT in $SNAPSHOTS
do
 echo "Deleting snapshot: $SNAPSHOT"
 curl -s -XDELETE "http://localhost:9200/_snapshot/$REPO/$SNAPSHOT?pretty"
done

echo "Done!"


########################################################
# Query All Snapshot
########################################################
echo "Quering current snapshot..."
outputSnaps="$(curl -s -XGET "localhost:9200/_snapshot/my_backup/_all?pretty")"
echo "$outputSnaps"
echo "Done!"

########################################################
# Packaging Snapshot
########################################################
echo "Packaging snapshots..."
cd /usr/share/elasticsearch/data/backup
outputAR="$(tar -zcvf elasticsearch-backup.tar.gz snapshot/)"
echo "Done - please check data/insight-data/elasticsearch-backup.tar.gz"

#Restore Example
#cd /tmp
#tar xzvf elasticsearch-backup.tar.gz
#curl -k –X POST \
#   -E /usr/share/elasticsearch/data/conf/reporting/elasticsearch/admin.crtfull.pem \
#   --key /usr/share/elasticsearch/data/conf/reporting/elasticsearch/admin.key.pem \
#   “$URL_REQ/<snapshot_name>/_restore?wait_for_completion=true”


