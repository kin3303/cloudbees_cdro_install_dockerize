#!/bin/bash

cd /tmp/scripts/elasticsearchbackup/

/usr/local/bin/mysqlbkup.sh 1>> /var/log/mysqlbkup.log 2>>/var/log/mysqlbkup-err.log
