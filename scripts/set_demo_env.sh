#!/bin/bash

AGENT_SCRIPT_FILE=create_agents.sh
echo "#!/bin/bash" > $AGENT_SCRIPT_FILE

echo 'export PATH=$PATH:/opt/electriccloud/electriccommander/bin' >> $AGENT_SCRIPT_FILE
echo 'ectool login admin changeme' >>  $AGENT_SCRIPT_FILE

for i in $(seq 1 $(docker ps |grep localagent | wc -l))
do
    AGENT_HOST=$(docker ps|grep "localagent_$i$"|awk '{print $1}')
    echo $AGENT_HOST
    echo "ectool deleteResource  local$i"  >>  $AGENT_SCRIPT_FILE
    echo "ectool createResource local$i --hostName $AGENT_HOST --pools pool$(expr $i % 5)" >> $AGENT_SCRIPT_FILE
    echo "ectool pingResource local$i" >> $AGENT_SCRIPT_FILE
done

docker exec $(docker ps |grep commanderserver_1|awk '{print $1}')   /tmp/scripts/create_agents.sh

