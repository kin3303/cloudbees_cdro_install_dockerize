#!/bin/bash

# Fail on any errors
set -e

# Find the root Git workspace directory.
ROOT=$(cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd)

echo "Logging into Commander..."
ectool --silent login admin changeme

echo "Creating groups..."
for i in administrators development quality release operations executive it; do
    ectool --silent createGroup $i
done

echo "Creating users..."
ectool --silent createUser anne --password changeme --fullUserName "Administrator Anne" --groupNames administrators --email "anne@flow.localdomain"
ectool --silent createUser dave --password changeme --fullUserName "Developer Dave" --groupNames development --email "dave@flow.localdomain"
ectool --silent createUser quinn --password changeme --fullUserName "Quality Quinn" --groupNames quality --email "quinn@flow.localdomain"
ectool --silent createUser raj --password changeme --fullUserName "Releaser Raj" --groupNames release --email "raj@flow.localdomain"
ectool --silent createUser oscar --password changeme --fullUserName "Operations Oscar" --groupNames operations --email "oscar@flow.localdomain"
ectool --silent createUser eddie --password changeme --fullUserName "Executive Eddie" --groupNames executive --email "eddie@flow.localdomain"
ectool --silent createUser ingrid --password changeme --fullUserName "IT Ingrid" --groupNames it --email "ingrid@flow.localdomain"

echo "Removing welcome popups..."
for i in anne dave quinn raj oscar eddie ingrid; do
    ectool --silent setProperty /users/$i/userSettings/showWelcome 0
done

echo "Setting top-level security policies..."
ectool --silent setProperty "/server/flow_demo/security_policy" --valueFile $ROOT/demo/security/policy.json 
ectool --silent runProcedure "/plugins/EC-Security/project" --procedureName ApplyPolicy --actualParameter "policyLocation=/server/flow_demo/security_policy" --pollInterval 1
