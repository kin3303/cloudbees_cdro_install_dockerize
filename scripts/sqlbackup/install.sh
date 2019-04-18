#!/bin/bash
set -e


cp mysqlbkup.sh /usr/local/bin
chmod 755 /usr/local/bin/mysqlbkup.sh

cp mysqlbkup.config /etc/mysqlbkup.config
chmod 600 /etc/mysqlbkup.config
cp mysqlbkup.cnf.sample /etc/mysqlbkup.cnf
chmod 600 /etc/mysqlbkup.cnf

. /etc/mysqlbkup.config
mkdir "$BACKUP_DIR"
chmod 600 "$BACKUP_DIR"

echo "mysqlbkup is installed"
echo "Make sure to edit /etc/mysqlbkup.cnf and /etc/mysqlbkup.config for your needs"

echo "Lastly, configure a crontab to execute the backup script periodically"
echo "For example, to schedule the script to run once daily"
echo "1 2 * * * /usr/local/bin/mysqlbkup.sh 1>> /var/log/mysqlbkup.log 2>>/var/log/mysqlbkup-err.log"
