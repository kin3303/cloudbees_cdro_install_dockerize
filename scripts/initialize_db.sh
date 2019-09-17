#!/bin/bash
/usr/local/mysqladmin password ecdb
/usr/local/mysql -u ecdb -pecdb < /tmp/scripts/initialize_db.sql
