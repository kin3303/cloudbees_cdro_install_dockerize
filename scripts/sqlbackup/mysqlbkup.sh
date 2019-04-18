#!/bin/bash
set -e

if [ -e /etc/mysqlbkup.config ]; then
    . /etc/mysqlbkup.config
fi

if [ -z "$BACKUP_DIR" ]; then
    echo 'Backup directory not set in configuration.' 1>&2
    exit 1
fi

if [ -z "$MAX_BACKUPS" ]; then
    echo 'Max backups not configured.' 1>&2
    exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backup directory $BACKUP_DIR does not exist." 1>&2
    exit 1
fi

for program in date $BKUP_BIN head hostname ls mysql mysqldump rm tr wc
do
    which $program 1>/dev/null 2>/dev/null
    if [ $? -gt 0 ]; then
        echo "External dependency $program not found or not in $PATH" 1>&2
        exit 1
    fi
done

date=$(date +%F)
backupDir="$BACKUP_DIR/ecdb"
backupFile="ecdb.sql.$BKUP_EXT"

echo "Backing up ecdb into $backupDir"

if [ ! -d "$backupDir" ]; then
   echo "Creating directory $backupDir"
   mkdir -p "$backupDir" 
fi

mysql_upgrade -u ecdb -pecdb -h db

echo "Running: mysqldump .. | $BKUP_BIN > $backupDir/$backupFile"
mysqldump -u ecdb -pecdb -h db "ecdb" | $BKUP_BIN > "$backupDir/$backupFile"
echo

echo "Finished running - $date"; echo
