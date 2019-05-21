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
  echo "Install Plugins"
  for file in /tmp/scripts/pluginResources/*.jar; do
    echo "Installing plugin $file..."
    ectool --silent promotePlugin \
    `ectool installPlugin $file --force true | grep -oPm1 "(?<=<pluginName>)[^<]+"`
     #ectool installPlugin "$file"
  done

  echo "Import Projects"
  for file in /tmp/scripts/projectResouces/*.xml; do
    ectool import --file "$file" --force 1
  done

  echo "Creating groups"
  for i in administrators development quality release operations executive it; do
    ectool --silent createGroup $i
  done

  echo "Creating users"
  ectool --silent createUser anne --password changeme --fullUserName "Administrator Anne" --groupNames administrators --email "anne@flow.localdomain"
  ectool --silent createUser dave --password changeme --fullUserName "Developer Dave" --groupNames development --email "dave@flow.localdomain"
  ectool --silent createUser quinn --password changeme --fullUserName "Quality Quinn" --groupNames quality --email "quinn@flow.localdomain"
  ectool --silent createUser raj --password changeme --fullUserName "Releaser Raj" --groupNames release --email "raj@flow.localdomain"
  ectool --silent createUser oscar --password changeme --fullUserName "Operations Oscar" --groupNames operations --email "oscar@flow.localdomain"
  ectool --silent createUser eddie --password changeme --fullUserName "Executive Eddie" --groupNames executive --email "eddie@flow.localdomain"
  ectool --silent createUser ingrid --password changeme --fullUserName "IT Ingrid" --groupNames it --email "ingrid@flow.localdomain"

  echo "Disable Sentry Monitor"
  ectool --silent  modifySchedule "Electric Cloud" ECSCM-SentryMonitor --scheduleDisabled true

  echo "Setting top-level security policies"
  ectool --silent setProperty "/server/flow_demo/security_policy" --valueFile  /tmp/scripts/projectResouces/policy.json 
  ectool --silent runProcedure "/plugins/EC-Security/project" --procedureName ApplyPolicy --actualParameter "policyLocation=/server/flow_demo/security_policy" --pollInterval 1

  touch /opt/electriccloud/electriccommander/conf/demo_ready
fi
