#!/bin/bash -ex

export PATH=$PATH:/opt/electriccloud/electriccommander/bin

ectool login admin changeme

if [ ! -f /opt/electriccloud/electriccommander/conf/demo_prod_agents_ready ]; then
  ectool createResource PROD --hostName  prodagent 
  ectool pingResource PROD
  touch /opt/electriccloud/electriccommander/conf/demo_prod_agents_ready
fi

if [ ! -f /opt/electriccloud/electriccommander/conf/demo_dev_agents_ready ]; then
  ectool createResource DEV --hostName  devagent 
  ectool pingResource DEV
  touch /opt/electriccloud/electriccommander/conf/demo_dev_agents_ready
fi

if [ ! -f /opt/electriccloud/electriccommander/conf/demo_qa_agents_ready ]; then
  ectool createResource QA --hostName  qaagent 
  ectool pingResource QA
  touch /opt/electriccloud/electriccommander/conf/demo_qa_agents_ready
fi


if [ ! -f /opt/electriccloud/electriccommander/conf/plugin_install_ready ]; then
  echo "Install Plugins"
  for file in /tmp/scripts/pluginResources/*.jar; do
    fileName=$(basename "$file")
    if [ $fileName = "ReleaseDemo.jar" ] ; then
      ectool installPlugin "$file"
    else
      ectool promotePlugin `ectool installPlugin $file --force true | grep -oPm1 "(?<=<pluginName>)[^<]+"`
    fi
  done

  touch /opt/electriccloud/electriccommander/conf/plugin_install_ready
fi


if [ ! -f /opt/electriccloud/electriccommander/conf/project_import_ready ]; then
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

  touch /opt/electriccloud/electriccommander/conf/project_import_ready
fi

if [ ! -f /opt/electriccloud/electriccommander/conf/project_group_settings_ready ]; then
  echo "Creating groups"
  for i in administrators development quality release operations executive it; do
    ectool createGroup $i
  done
  touch /opt/electriccloud/electriccommander/conf/project_group_settings_ready
fi

echo "Disable Schedules"
ectool --silent  modifySchedule "Electric Cloud" "ECSCM-SentryMonitor" --scheduleDisabled true
ectool --silent  modifySchedule "Electric Cloud" "Report Recent Job Outcome" --scheduleDisabled true
ectool --silent  modifySchedule "Electric Cloud" "Report Recent Job Trend" --scheduleDisabled true
ectool --silent  modifySchedule "Electric Cloud" "ReportSchedule" --scheduleDisabled true

echo "Plugin Modification"
ectool --silent  modifyProject "/plugins/EC-JIRA/project" --resourceName "local" --workspaceName "default"
