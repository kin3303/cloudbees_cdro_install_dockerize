#!/bin/bash
set -e

export PATH=$PATH:/opt/electriccloud/electriccommander/bin

ectool login admin changeme

if [ ! -f /opt/electriccloud/electriccommander/conf/demo_agents_ready ]; then

  ectool createResource PROD --hostName  prodagent 
  ectool pingResource repositoryAgent
  
  ectool createResource DEV --hostName  devagent 
  ectool pingResource repositoryAgent
  
  ectool createResource QA --hostName  qaagent 
  ectool pingResource repositoryAgent
  
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

#echo "Creating users"
#ectool createUser anne --password changeme --fullUserName "Administrator Anne" --groupNames administrators --email "anne@flow.localdomain"
#ectool createUser dave --password changeme --fullUserName "Developer Dave" --groupNames development --email "dave@flow.localdomain"
#ectool createUser quinn --password changeme --fullUserName "Quality Quinn" --groupNames quality --email "quinn@flow.localdomain"
#ectool createUser raj --password changeme --fullUserName "Releaser Raj" --groupNames release --email "raj@flow.localdomain"
#ectool createUser oscar --password changeme --fullUserName "Operations Oscar" --groupNames operations --email "oscar@flow.localdomain"
#ectool createUser eddie --password changeme --fullUserName "Executive Eddie" --groupNames executive --email "eddie@flow.localdomain"
#ectool createUser ingrid --password changeme --fullUserName "IT Ingrid" --groupNames it --email "ingrid@flow.localdomain"


#echo "Setting top-level security policies"
#ectool --silent setProperty "/server/flow_demo/security_policy" --valueFile  /tmp/scripts/projectResouces/policy.json 
#ectool --silent runProcedure "/plugins/EC-Security/project" --procedureName ApplyPolicy --actualParameter "policyLocation=/server/flow_demo/security_policy" --pollInterval 1

