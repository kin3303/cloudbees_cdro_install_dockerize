FROM kin3303/commanderbase
LABEL maintainer="dkim"

ARG EFLOW_INSTALLER

ADD ${EFLOW_INSTALLER} /tmp/
RUN chmod +x /tmp/${EFLOW_INSTALLER}
RUN /tmp/${EFLOW_INSTALLER} --mode silent \
--installRepository \
--installAgent \
--unixServerUser ubuntu \
--unixServerGroup ubuntu \
--unixAgentUser ubuntu \
--unixAgentGroup ubuntu 
#--remoteServer haproxy; exit 0

RUN  sed -i -e "s/^COMMANDER_HOST=localhost/COMMANDER_HOST=haproxy/g" /opt/electriccloud/electriccommander/conf/repository/server.properties

RUN rm -f /tmp/${EFLOW_INSTALLER}

EXPOSE 8200

CMD /etc/init.d/commanderRepository start && /etc/init.d/commanderAgent console
