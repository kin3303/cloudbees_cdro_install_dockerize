#!/bin/bash
set -e

export PATH=$PATH:/opt/electriccloud/electriccommander/bin

ectool login admin changeme

if [ ! -f /opt/electriccloud/electriccommander/conf/license_ready ]; then
  ectool importLicenseData /opt/electriccloud/electriccommander/conf/license.xml 
  ectool setProperty "/server/settings/ipAddress" "haproxy"
  ectool setProperty "/server/settings/stompClientUri" "stomp+ssl://haproxy:61613"
  ectool setProperty "/server/settings/stompSecure" "true"
  touch /opt/electriccloud/electriccommander/conf/license_ready
fi

if [ ! -f /opt/electriccloud/electriccommander/conf/agents_ready ]; then
  ectool createResource local --hostName localagent
  ectool pingResource local
  
  ectool createResource apacheAgent --hostName  commanderapache 
  ectool pingResource apacheAgent
  
  ectool createResource repositoryAgent --hostName  repository 
  ectool pingResource repositoryAgent
  
  ectool createResource PROD --hostName  prodagent 
  ectool pingResource repositoryAgent
  
  ectool createResource DEV --hostName  devagent 
  ectool pingResource repositoryAgent
  
  ectool createResource QA --hostName  qaagent 
  ectool pingResource repositoryAgent
  
  touch /opt/electriccloud/electriccommander/conf/agents_ready
fi

if [ ! -f /opt/electriccloud/electriccommander/conf/repository_ready ]; then
  ectool createRepository default --repositoryDisabled "false" --url  "https://repository:8200" 
  touch /opt/electriccloud/electriccommander/conf/repository_ready
fi

#if [ ! -f /opt/electriccloud/electriccommander/conf/insight_ready ]; then
#  ectool setDevOpsInsightServerConfiguration --userName reportuser --password changeme --enabled 1 \
#  --logStashUrl  http://insight:9500  --elasticSearchUrl http://insight:9200 --testConnection 1
#  touch /opt/electriccloud/electriccommander/conf/insight_ready
#fi

if [ ! -f /opt/electriccloud/electriccommander/conf/demo_ready ]; then 
  for file in /tmp/scripts/pluginResources/*.jar; do
    echo "Installing plugin $file..."
    ectool --silent promotePlugin \
    ectool installPlugin "$file"
    `ectool installPlugin $file --force true | grep -oPm1 "(?<=<pluginName>)[^<]+"`
  done

  for file in /tmp/scripts/projectResouces/*.xml; do
    ectool import --file "$file" --force 1
  done
  
  ectool --silent  modifySchedule "Electric Cloud" ECSCM-SentryMonitor --scheduleDisabled true
  ectool --silent createAclEntry user "project: CO_DEMO" --systemObjectName resources --executePrivilege allow --readPrivilege allow --modifyPrivilege allow
  ectool --silent createAclEntry user "project: CO_DEMO" --systemObjectName projects --executePrivilege allow --readPrivilege allow --modifyPrivilege allow
  ectool --silent createAclEntry user "project: CO_DEMO" --systemObjectName server --executePrivilege allow --readPrivilege allow --modifyPrivilege inherit

  touch /opt/electriccloud/electriccommander/conf/demo_ready
fi
