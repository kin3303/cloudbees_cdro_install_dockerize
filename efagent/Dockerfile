FROM kin3303/commanderbase

LABEL maintainer="dkim"
USER root

ARG EFLOW_INSTALLER

# Install dependencies                                      
RUN apt-get update \
    && apt-get install -y git build-essential curl wget software-properties-common xmlstarlet bsdtar unzip curl

ADD ${EFLOW_INSTALLER} /tmp/
RUN chmod +x /tmp/${EFLOW_INSTALLER}
RUN /tmp/${EFLOW_INSTALLER} --mode silent --installAgent --unixAgentUser ubuntu --unixAgentGroup ubuntu  --remoteServer haproxy
RUN rm -f /tmp/${EFLOW_INSTALLER}

EXPOSE 7800
CMD /etc/init.d/commanderAgent start && tail -F /opt/electriccloud/electriccommander/logs/agent/agent.log
