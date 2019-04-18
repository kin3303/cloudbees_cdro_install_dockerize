#!/bin/bash

cd /tmp/scripts/sqlbackup/
./install.sh
/usr/local/bin/mysqlbkup.sh 1>> /var/log/mysqlbkup.log 2>>/var/log/mysqlbkup-err.log

echo "-------------Error Log -----------------------------------------"
echo ""
cat /var/log/mysqlbkup-err.log
echo ""
echo "-------------Backup Log -----------------------------------------"
echo ""
cat /var/log/mysqlbkup.log
echo ""
