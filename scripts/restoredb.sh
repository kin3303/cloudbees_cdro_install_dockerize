#!/bin/bash

for filename in  /var/lib/mysql/backup/*.gz; do
  gunzip < $filename | mysql -h db -u ecdb -pecdb "ecdb"
done 
