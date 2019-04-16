FROM kin3303/commanderbase
LABEL maintainer="dkim"
 
RUN mkdir -p /tmp/elkdata
RUN mkdir -p /tmp/elktemp

ARG EFLOW_DEV_INSTALLER

ADD ${EFLOW_DEV_INSTALLER} /tmp/
RUN chmod +x /tmp/${EFLOW_DEV_INSTALLER}
RUN /tmp/${EFLOW_DEV_INSTALLER}  --mode silent \ 
--disableSSL \
--elasticsearchDataDirectory /tmp/elkdata \
-- elasticsearchRegenerateCertificates \
--hostName localhost \ 
--remoteServer haproxy \
--remoteServerPassword changeme \
--remoteServerUser admin \
--temp /tmp/elktemp \
--unixServerGroup ubuntu \
--unixServerUser ubuntu
 
RUN rm -f /tmp/${EFLOW_DEV_INSTALLER}

 
#ignore the server mismatch and passkey mismatch
#RUN echo "set.default.COMMANDER_IGNORE_SERVER_MISMATCH=1" >> /opt/electriccloud/electriccommander/conf/wrapper.conf
#RUN echo "set.default.COMMANDER_IGNORE_PASSKEY_MISMATCH=1" >> /opt/electriccloud/electriccommander/conf/wrapper.conf

EXPOSE 9200 9300 9500 9600 

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.5.0/wait /wait
RUN chmod +x /wait
 
CMD /wait && \ 
/etc/init.d/commanderElasticsearch restart && \
/etc/init.d/commanderLogstash restart && \
tail -F /opt/electriccloud/reportserv/logs/reporting/elasticsearch.log
