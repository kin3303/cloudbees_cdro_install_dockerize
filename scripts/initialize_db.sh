#!/bin/bash
mysqladmin -u ecdb password ecdb

mysql --user=ecdb --password=ecdb <<EOF
drop database if exists univers;
create database univers;
grant all on *.* to ecdb@localhost IDENTIFIED BY 'ecdb';
use univers;
EOF
