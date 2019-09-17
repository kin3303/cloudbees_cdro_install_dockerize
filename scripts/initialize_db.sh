#!/bin/bash
mysqladmin -u ecdb password ecdb

mysql --user=root --password=ecdb <<EOF
drop database if exists univers;
create database univers;
grant all on *.* to root@localhost IDENTIFIED BY 'ecdb';
use univers;
EOF
