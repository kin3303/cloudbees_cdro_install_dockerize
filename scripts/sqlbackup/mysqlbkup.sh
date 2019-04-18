#!/bin/bash

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
dbs=$(echo 'show databases' | mysql --defaults-file=$DEFAULTS_FILE )

for db in $dbs
do
    backupDir="$BACKUP_DIR/$db"
    backupFile="$date-$db.sql.$BKUP_EXT"
    echo "Backing up $db into $backupDir"

    if [ ! -d "$backupDir" ]; then
        echo "Creating directory $backupDir"
        mkdir -p "$backupDir"
    else
        numBackups=$(ls -1lt "$backupDir"/*."$BKUP_EXT" 2>/dev/null | wc -l) 
        if [ -z "$numBackups" ]; then numBackups=0; fi

        if [ "$numBackups" -ge "$MAX_BACKUPS" ]; then
            # how many files to nuke
            ((numFilesToNuke = "$numBackups - $MAX_BACKUPS + 1"))
            # actual files to nuke
            filesToNuke=$(ls -1rt "$backupDir"/*."$BKUP_EXT" | head -n "$numFilesToNuke" | tr '\n' ' ')

            echo "Nuking files $filesToNuke"
            rm $filesToNuke
        fi
    fi

    echo "Running: mysqldump .. | $BKUP_BIN > $backupDir/$backupFile"
    mysqldump -uecdb -pecdb "ecdb" | $BKUP_BIN > "$backupDir/$backupFile"
    echo
done

echo "Finished running - $date"; echo
