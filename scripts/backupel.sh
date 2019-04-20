#!/bin/bash

cd /tmp/scripts/elasticsearchbackup/

#sbkup.sh /usr/local/bin
chmod 755 esbkup.sh

./esbkup.sh 1>> /var/log/esbkup.log 2>>/var/log/esbkup-err.log

echo "-------------Error Log -----------------------------------------"
echo ""
cat /var/log/esbkup-err.log
echo ""
echo "-------------Backup Log -----------------------------------------"
echo ""
cat /var/log/esbkup.log
echo ""
