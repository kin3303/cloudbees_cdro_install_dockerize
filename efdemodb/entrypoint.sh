#!/bin/bash

#if [ "$INIT" = "1" ]; then
        echo "Initializing $DATADIR..."
        mysql_install_db
#fi

echo "Checking integrity of data from $DATADIR..."
/usr/sbin/mysqld &
TMPPID=$!
sleep 15

mysql -u root "SHOW databases; USE mysql;"

kill -TERM $TMPPID && wait
STATUS=$?

if [ "$STATUS" = "0" ]; then
        echo "Using data from $DATADIR..."
        /etc/init.d/mysql start && /etc/init.d/commanderAgent start && tail -F /opt/electriccloud/electriccommander/logs/agent/agent.log
else
        echo "Cannot load data from $DATADIR."
fi
