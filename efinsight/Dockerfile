FROM kin3303/commanderbase
LABEL maintainer="dkim"
 
ARG EFLOW_DEV_INSTALLER

ADD ${EFLOW_DEV_INSTALLER} /tmp/
RUN chmod +x /tmp/${EFLOW_DEV_INSTALLER}
RUN /tmp/${EFLOW_DEV_INSTALLER}  --mode silent \
--dataDirectory /opt/electriccloud/electriccommander \
--disableSSL \
--elasticsearchDataDirectory /opt/electriccloud/electriccommander \
--elasticsearchIndexNumberOfShards 2 \
--elasticsearchInternalPort 9300 \
--elasticsearchMemoryMB 2048 \
--elasticsearchPort 9200 \
-- elasticsearchRegenerateCertificates \
--elasticsearchUserPassword changeme \
--hostName efinsightserver \
--installDirectory /opt/electriccloud/electriccommander \
--logstashInitMemoryMB 256 \
--logstashInternalPort 9600 \
--logstashMaxMemoryMB 1024 \
--logstashPort 9500 \
--remoteServer haproxy \
--remoteServerPassword changeme \
--remoteServerUser admin \
--temp /tmp \
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
