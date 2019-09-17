#!/bin/bash
mysqladmin password ecdb
mysql -u ecdb -pecdb < /tmp/scripts/initialize_db.sql
