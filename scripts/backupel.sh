#!/bin/bash

cd /tmp/scripts/elasticsearchbackup/

cp esbkup.sh /usr/local/bin
chmod 755 /usr/local/bin/esbkup.sh

/usr/local/bin/esbkup.sh 1>> /var/log/esbkup.log 2>>/var/log/esbkup-err.log
