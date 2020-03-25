FROM kin3303/commanderbase
LABEL maintainer="dkim"

ARG FLOW_INSTALLER

ADD ${FLOW_INSTALLER} /tmp/
RUN chmod +x /tmp/${FLOW_INSTALLER}
RUN /tmp/${FLOW_INSTALLER} --mode silent \
--installRepository \
--installAgent \
--unixServerUser ubuntu \
--unixServerGroup ubuntu \
--unixAgentUser ubuntu \
--unixAgentGroup ubuntu 

RUN  sed -i -e "s/^COMMANDER_HOST=localhost/COMMANDER_HOST=flow/g" /opt/electriccloud/electriccommander/conf/repository/server.properties

RUN rm -f /tmp/${FLOW_INSTALLER}

RUN /etc/init.d/commanderRepository restart 

EXPOSE 8200

CMD /etc/init.d/commanderRepository start && /etc/init.d/commanderAgent console
