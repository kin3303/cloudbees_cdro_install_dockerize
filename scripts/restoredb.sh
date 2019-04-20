#!/bin/bash

FILES=/var/lib/mysql/backup/ecdb/*
for filename in  $FILES; do
  gunzip < $filename | mysql -h db -u ecdb -pecdb "ecdb"
done 
