#!/bin/bash
mysqladmin -u ecdb password ecdb
mysql -u ecdb -p < /tmp/scripts/initialize_db.sql
