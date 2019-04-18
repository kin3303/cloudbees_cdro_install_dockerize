#!/bin/bash
set -e

chmod 755 mysqlbkup.sh 
cp mysqlbkup.sh /usr/local/bin
chmod 755 /usr/local/bin/mysqlbkup.sh

cp mysqlbkup.config /etc/mysqlbkup.config
chmod 600 /etc/mysqlbkup.config
 
. /etc/mysqlbkup.config
chmod 600 "$BACKUP_DIR"
