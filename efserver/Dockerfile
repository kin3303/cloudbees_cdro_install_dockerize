FROM kin3303/commanderbase
LABEL maintainer="dkim"
 
ARG FLOW_INSTALLER

ADD ${FLOW_INSTALLER} /tmp/
RUN chmod +x /tmp/${FLOW_INSTALLER}
RUN /tmp/${FLOW_INSTALLER}  --mode silent --installServer --unixServerUser ubuntu --unixServerGroup ubuntu --unixAgentUser ubuntu --unixAgentGroup ubuntu
RUN rm -f /tmp/${FLOW_INSTALLER}

COPY ./mysql-connector-java.jar /opt/electriccloud/electriccommander/server/lib/mysql-connector-java.jar
# COPY ./mssql-jdbc-8.4.1.jre11.jar /opt/electriccloud/electriccommander/server/lib/mssql-jdbc-8.4.1.jre11.jar

RUN sed -i -e 's/COMMANDER_SERVER_NAME=.*/COMMANDER_SERVER_NAME=flow/' /opt/electriccloud/electriccommander/conf/commander.properties 

EXPOSE 8443 61613 8000 5445-5449

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.5.0/wait /wait
RUN chmod +x /wait
 
CMD /wait && \ 
chmod +x /tmp/scripts/*.sh && \
/tmp/scripts/initiate_zoo.sh && \
tail -F /opt/electriccloud/electriccommander/logs/commander-`hostname`.log
