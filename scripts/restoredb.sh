#!/bin/bash

for filename in  /var/lib/mysql/backup/*.sql.gz; do
  gunzip < /var/lib/mysql/backup/$filename | mysql -h db -u ecdb -pecdb "ecdb"
done 
