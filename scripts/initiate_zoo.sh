#!/bin/bash
set -e

export PATH=$PATH:/opt/electriccloud/electriccommander/bin

. /opt/electriccloud/electriccommander/bash.profile

/etc/init.d/commanderServer restart

while [ ! -f /opt/electriccloud/electriccommander/logs/commander-`hostname`.log ]
do
  sleep 2
done
