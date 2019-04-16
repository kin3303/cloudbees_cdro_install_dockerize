#!/bin/bash
set -e

export PATH=$PATH:/opt/electriccloud/electriccommander/bin

function wait_for_service()
 if [ $# -ne 1 ]
  then
    echo usage $FUNCNAME "service";
    echo e.g: $FUNCNAME docker-proxy
  else
serviceName=$1

while true; do
    REPLICAS=$(docker service ls | grep -E "(^| )$serviceName( |$)" | awk '{print $3}')
    if [[ $REPLICAS == "1/1" ]]; then
        break
    else
        echo "Waiting for the $serviceName service... ($REPLICAS)"
        sleep 5
    fi
done
fi

. /opt/electriccloud/electriccommander/bash.profile

if [ ! -f /opt/electriccloud/electriccommander/conf/server_ready ]; then
  #echo "sleep 5 senconds to wait zookeeper start"
  #sleep 10
  wait_for_service zookeeper1
  wait_for_service zookeeper2
  wait_for_service zookeeper3
  
  cd /opt/electriccloud/electriccommander/conf
  COMMANDER_ZK_CONNECTION=zookeeper1:2181 ../jre/bin/java -jar \
      ../server/bin/zk-config-tool-jar-with-dependencies.jar com.electriccloud.commander.cluster.ZKConfigTool \
      --databasePropertiesFile database.properties \
      --keystoreFile keystore \
      --passkeyFile passkey \
     --commanderPropertiesFile commander.properties
   touch /opt/electriccloud/electriccommander/conf/server_ready
fi

/etc/init.d/commanderServer restart

while [ ! -f /opt/electriccloud/electriccommander/logs/commander-`hostname`.log ]
do
  sleep 2
done
