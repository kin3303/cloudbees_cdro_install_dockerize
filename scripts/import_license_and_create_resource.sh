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
  ectool createResource local --hostName localagent --pools default
  ectool pingResource local
  ectool createResource apacheAgent --hostName  commanderapache 
  ectool pingResource apacheAgent
  ectool createResource repositoryAgent --hostName  repository 
  ectool pingResource repositoryAgent
  touch /opt/electriccloud/electriccommander/conf/agents_ready
fi

if [ ! -f /opt/electriccloud/electriccommander/conf/repository_ready ]; then
  ectool createRepository myRepo --repositoryDisabled "false" --url  "https://repository:8200" 
  touch /opt/electriccloud/electriccommander/conf/repository_ready
fi

if [ ! -f /opt/electriccloud/electriccommander/conf/insight_ready ]; then
  ectool setDevOpsInsightServerConfiguration --userName reportuser --password changeme --enabled 1 \
  --logStashUrl  http://insight:9500  --elasticSearchUrl http://insight:9200 --testConnection 1
  touch /opt/electriccloud/electriccommander/conf/insight_ready
fi

