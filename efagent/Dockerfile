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

RUN  sed -i -e 's/wrapper.java.initmemory=16/wrapper.java.initmemory=256/g' /opt/electriccloud/electriccommander/apache/conf/httpd.conf
RUN  sed -i -e 's/wrapper.java.maxmemory=64/wrapper.java.maxmemory=512/g' /opt/electriccloud/electriccommander/apache/conf/httpd.conf

EXPOSE 7800
CMD /etc/init.d/commanderAgent start && tail -F /opt/electriccloud/electriccommander/logs/agent/agent.log
