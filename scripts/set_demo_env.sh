#!/bin/bash
set -e

export PATH=$PATH:/opt/electriccloud/electriccommander/bin

ectool login admin changeme

if [ ! -f /opt/electriccloud/electriccommander/conf/demo_agents_ready ]; then

  ectool createResource PROD --hostName  prodagent 
  ectool pingResource prodagent
  
  ectool createResource DEV --hostName  devagent 
  ectool pingResource devagent
  
  ectool createResource QA --hostName  qaagent 
  ectool pingResource qaagent
  
  ectool createResource DB --hostName  dbagent 
  ectool pingResource dbagent 
  
  
  touch /opt/electriccloud/electriccommander/conf/demo_agents_ready
fi

echo "Install Plugins"
for file in /tmp/scripts/pluginResources/*.jar; do
  fileName=$(basename "$file")
  if [ $fileName = "ReleaseDemo.jar" ] ; then
    ectool installPlugin "$file"
  else
    ectool promotePlugin `ectool installPlugin $file --force true | grep -oPm1 "(?<=<pluginName>)[^<]+"`
  fi
done

echo "Import Projects"
for file in /tmp/scripts/projectResouces/*.xml; do
  ectool import --file "$file" --force 1
  
  fileName=$(basename "$file")
  projectName=${fileName%.*}
 
  ectool createAclEntry user "project: $projectName" --systemObjectName server --executePrivilege allow --readPrivilege allow --modifyPrivilege allow --changePermissionsPrivilege allow
  ectool createAclEntry user "project: $projectName" --systemObjectName projects --executePrivilege allow --readPrivilege allow --modifyPrivilege allow --changePermissionsPrivilege allow
  ectool createAclEntry user "project: $projectName" --systemObjectName resources --executePrivilege allow --readPrivilege allow --modifyPrivilege allow --changePermissionsPrivilege allow
  ectool createAclEntry user "project: $projectName" --systemObjectName artifacts --executePrivilege allow --readPrivilege allow --modifyPrivilege allow --changePermissionsPrivilege allow
  ectool createAclEntry user "project: $projectName" --systemObjectName repositories --executePrivilege allow --readPrivilege allow --modifyPrivilege allow --changePermissionsPrivilege allow
  ectool createAclEntry user "project: $projectName" --systemObjectName session --executePrivilege allow --readPrivilege allow --modifyPrivilege allow --changePermissionsPrivilege allow
  ectool createAclEntry user "project: $projectName" --systemObjectName workspaces --executePrivilege allow --readPrivilege allow --modifyPrivilege allow --changePermissionsPrivilege allow
done

echo "Creating groups"
for i in administrators development quality release operations executive it; do
  ectool createGroup $i
done

echo "Disable Sentry Monitor"
ectool --silent  modifySchedule "Electric Cloud" ECSCM-SentryMonitor --scheduleDisabled true

echo "Plugin Modification"
ectool --silent  modifyProject "/plugins/EC-JIRA/project" --resourceName "local" --workspaceName "default"

echo "Setting JBoss credentials..."
ectool --silent runProcedure /plugins/EC-JBoss/project --procedureName CreateConfiguration \
       --actualParameter config=jbosscfg jboss_url="localhost:9990" --pollInterval 20
ectool --silent modifyCredential /plugins/EC-JBoss/project jbosscfg --userName admin --password changeme


echo "Setting MySQL credentials..."
ectool --silent runProcedure /plugins/EC-MYSQL/project --procedureName CreateConfiguration \
       --actualParameter config=mysqlcfg --pollInterval 20
ectool --silent modifyCredential /plugins/EC-MYSQL/project mysqlcfg --userName root --password password


ectool --silent runProcedure /plugins/ECSCM-Git/project --procedureName CreateConfiguration \
       --actualParameter config=gitcfg --pollInterval 20
ectool --silent modifyCredential /plugins/ECSCM-Git/project gitcfg --userName kin3303 --password eodnddk!QAZ2wsx

