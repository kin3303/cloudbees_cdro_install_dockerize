#!/bin/bash
set -e

export PATH=$PATH:/opt/electriccloud/electriccommander/bin

ectool login admin changeme

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
done

echo "Creating groups"
for i in administrators development quality release operations executive it; do
  ectool createGroup $i
done

echo "Creating users"
ectool createUser anne --password changeme --fullUserName "Administrator Anne" --groupNames administrators --email "anne@flow.localdomain"
ectool createUser dave --password changeme --fullUserName "Developer Dave" --groupNames development --email "dave@flow.localdomain"
ectool createUser quinn --password changeme --fullUserName "Quality Quinn" --groupNames quality --email "quinn@flow.localdomain"
ectool createUser raj --password changeme --fullUserName "Releaser Raj" --groupNames release --email "raj@flow.localdomain"
ectool createUser oscar --password changeme --fullUserName "Operations Oscar" --groupNames operations --email "oscar@flow.localdomain"
ectool createUser eddie --password changeme --fullUserName "Executive Eddie" --groupNames executive --email "eddie@flow.localdomain"
ectool createUser ingrid --password changeme --fullUserName "IT Ingrid" --groupNames it --email "ingrid@flow.localdomain"

echo "Disable Sentry Monitor"
ectool --silent  modifySchedule "Electric Cloud" ECSCM-SentryMonitor --scheduleDisabled true

echo "Setting top-level security policies"
ectool --silent setProperty "/server/flow_demo/security_policy" --valueFile  /tmp/scripts/projectResouces/policy.json 
ectool --silent runProcedure "/plugins/EC-Security/project" --procedureName ApplyPolicy --actualParameter "policyLocation=/server/flow_demo/security_policy" --pollInterval 1

