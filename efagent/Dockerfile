FROM kin3303/commanderbase

LABEL maintainer="dkim"
USER root

ARG FLOW_INSTALLER

# Install dependencies                                      
RUN apt-get update \
    && apt-get install -y git build-essential curl wget software-properties-common xmlstarlet bsdtar unzip curl

ADD ${FLOW_INSTALLER} /tmp/
RUN chmod +x /tmp/${FLOW_INSTALLER}
RUN /tmp/${FLOW_INSTALLER} --mode silent --installAgent --unixAgentUser ubuntu --unixAgentGroup ubuntu  --remoteServer flow
RUN rm -f /tmp/${FLOW_INSTALLER}

RUN  sed -i -e 's/wrapper.java.initmemory=16/wrapper.java.initmemory=256/g' /opt/electriccloud/electriccommander/conf/agent/wrapper.conf
RUN  sed -i -e 's/wrapper.java.maxmemory=64/wrapper.java.maxmemory=512/g' /opt/electriccloud/electriccommander/conf/agent/wrapper.conf

RUN /etc/init.d/commanderServer restart

EXPOSE 7800
CMD /etc/init.d/commanderAgent start && tail -F /opt/electriccloud/electriccommander/logs/agent/agent.log
