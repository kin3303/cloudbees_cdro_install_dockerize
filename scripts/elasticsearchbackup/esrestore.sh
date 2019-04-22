#!/bin/bash
cd /usr/share/elasticsearch/backup
tar xzvf elasticsearch-backup.tar.gz

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
sleep 10

########################################################
# Add Repository
########################################################
echo "Adding Repository"
outputAR="$(curl -XPUT 'http://localhost:9200/_snapshot/my_backup' -d '{"type":"fs","settings":{"location": "/usr/share/elasticsearch/backup/snapshot","compress": true}}')"
echo "Done"


########################################################
# Restore 
########################################################
curl -k -X POST "localhost:9200/_snapshot/my_backup/insight/_restore?wait_for_completion=true"
