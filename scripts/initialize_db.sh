#!/bin/bash
mysqladmin -u ecdb password ecdb
mysql -u ecdb -pecdb < /tmp/scripts/initialize_db.sql
