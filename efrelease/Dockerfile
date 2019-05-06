FROM andreptb/tomcat

LABEL maintainer="dkim"
USER root

# INSTALL EF Agent
ARG EFLOW_INSTALLER
ADD ${EFLOW_INSTALLER} /tmp/
RUN chmod +x /tmp/${EFLOW_INSTALLER}
RUN /tmp/${EFLOW_INSTALLER} --mode silent --installAgent --unixAgentUser ubuntu --unixAgentGroup ubuntu  --remoteServer haproxy
RUN rm -f /tmp/${EFLOW_INSTALLER}

EXPOSE 8080
EXPOSE 7800
CMD /etc/init.d/commanderAgent start &&  catalina.sh run
