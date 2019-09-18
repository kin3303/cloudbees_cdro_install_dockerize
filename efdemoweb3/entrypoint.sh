#!/bin/bash

if [ ! -f /tmp/mysql_ready ]; then
  echo "Initializing $DATADIR..."
  mysql_install_db
  touch /tmp/mysql_ready
fi

echo "Checking integrity of data from $DATADIR..."
/usr/sbin/mysqld &
TMPPID=$!
sleep 15

mysql --user=root --password=password "SHOW databases; USE mysql;"

mysqladmin -u root password 'testdb'

mysql --user=root --password=testdb <<EOF
grant all on *.* to root@localhost IDENTIFIED BY 'testdb';
drop database if exists univers;
create database univers;
use univers;
EOF

kill -TERM $TMPPID && wait
STATUS=$?

if [ "$STATUS" = "0" ]; then
        echo "Using data from $DATADIR..."
        echo "Starting mysql and wildfly services.."
        /etc/init.d/mysql start && /etc/init.d/wildfly start && /etc/init.d/commanderAgent start && tail -F /opt/electriccloud/electriccommander/logs/agent/agent.log
else
        echo "Cannot load data from $DATADIR."
fi
