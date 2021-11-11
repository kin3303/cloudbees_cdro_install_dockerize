#!/bin/bash

read -p 'Enter the username to use: ' EC_AGENT_USER
read -p 'Enter the group to use: ' EC_AGENT_GROUP
read -p 'Enter the install file name: ' FLOW_INSTALLER
read -p 'Enter the remote server ip: ' REMOTE_SERVER
read -p 'Enter the remote server user name: ' REMOTE_USER
read -p 'Enter the remote server user password: ' REMOTE_PASS
read -p 'Enter the remote agent ip: ' AGENT_IP 

#Check Input params
EXIST_USER=0
UIDS=$(getent passwd | cut -d: -f1)
for user in ${UIDS}
do
	group=$(getent group ${user} | cut -d: -f1)
	if [[ "${user}" = "${EC_AGENT_USER}" && "${group}" = "${EC_AGENT_GROUP}" ]]
	then
		EXIST_USER=1
	fi
done


if [[ ${EXIST_USER} -eq 0 ]]
then
	echo "Please check if the user you entered is a valid user."
	exit 1;
fi



# Silent Installation
chmod +x ./${FLOW_INSTALLER}

./${FLOW_INSTALLER} \
	--mode silent \
	--installAgent \
	--remoteServer "${REMOTE_SERVER}" \
	--remoteServerUser "${REMOTE_USER}" \
	--agentInitMemoryMB 256 \
	--agentMaxMemoryMB 512 \
	--unixAgentGroup  "${EC_AGENT_USER}" \
	--unixAgentUser  "${EC_AGENT_GROUP}" \
	--agentLocalPort "6800" \
	--agentPort "7800" \
	--remoteServerPassword "${REMOTE_PASS}"


if [[ "${?}" -ne 0 ]]
then
   echo "Installation failed.."
fi

# Register Agent
export PATH=$PATH:/opt/electriccloud/electriccommander/bin
ectool --server "${REMOTE_SERVER}" login "${REMOTE_USER}" "${REMOTE_PASS}" 
ectool deleteResource testAgent
ectool createResource testAgent --hostName  ${AGENT_IP} 
ectool pingResource testAgent


# Service Restart
/etc/init.d/commanderAgent restart && tail -F /opt/electriccloud/electriccommander/logs/agent/agent.log


