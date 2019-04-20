#!/bin/bash
cd /usr/share/elasticsearch/backup
tar xzvf elasticsearch-backup.tar.gz

curl -k -X POST "localhost:9200/_snapshot/my_backup/insight/_restore?wait_for_completion=true"
