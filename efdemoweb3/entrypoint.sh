#!/bin/bash

echo "Initializing $DATADIR..."
mysql_install_db

echo "Checking integrity of data from $DATADIR..."
/usr/sbin/mysqld &
TMPPID=$!
sleep 15

mysql --user=root --password=password "SHOW databases; USE mysql;"

mysqladmin -u root password '$PASSWORD'

kill -TERM $TMPPID && wait
STATUS=$?

if [ "$STATUS" = "0" ]; then
        echo "Using data from $DATADIR..."
        echo "Starting mysql and wildfly services.."
        /etc/init.d/mysql start && /etc/init.d/wildfly start && /etc/init.d/commanderAgent start && tail -F /opt/electriccloud/electriccommander/logs/agent/agent.log
else
        echo "Cannot load data from $DATADIR."
fi
