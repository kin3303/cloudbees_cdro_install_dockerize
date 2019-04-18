#!/bin/bash

# Deploy the executable
cp mysqlbkup.sh /usr/local/bin
chmod 755 /usr/local/bin/mysqlbkup.sh

# Deploy the configuration files
cp mysqlbkup.config.sample /etc/mysqlbkup.config
chmod 600 /etc/mysqlbkup.config
cp mysqlbkup.cnf.sample /etc/mysqlbkup.cnf
chmod 600 /etc/mysqlbkup.cnf

# Create the backup directory
. /etc/mysqlbkup.config

if [ ! -d "$BACKUP_DIR" ]; then
   echo "Creating directory $backupDir"
   mkdir -p "$BACKUP_DIR"
fi    
chmod 600 "$BACKUP_DIR"

# Inform 
echo "mysqlbkup is installed"
echo "Make sure to edit /etc/mysqlbkup.cnf and /etc/mysqlbkup.config for your needs"
echo "/usr/local/bin/mysqlbkup.sh 1>> /var/log/mysqlbkup.log 2>>/var/log/mysqlbkup-err.log"
