#!/bin/bash
set -e

export PATH=$PATH:/opt/electriccloud/electriccommander/bin
. /opt/electriccloud/electriccommander/bash.profile

#if [ ! -f /opt/electriccloud/electriccommander/conf/zoo_ready ]; then
#  echo "sleep 20 senconds to wait zookeeper adnd db start"
  sleep 5
  
  cd /opt/electriccloud/electriccommander/conf
  COMMANDER_ZK_CONNECTION=zookeeper1:2181 ../jre/bin/java -jar \
      ../server/bin/zk-config-tool-jar-with-dependencies.jar com.electriccloud.commander.cluster.ZKConfigTool \
      --databasePropertiesFile database.properties \
      --keystoreFile keystore \
      --passkeyFile passkey \
     --commanderPropertiesFile commander.properties
#fi

#touch /opt/electriccloud/electriccommander/conf/zoo_ready
