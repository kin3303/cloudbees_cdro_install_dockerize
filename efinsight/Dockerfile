FROM kin3303/commanderbase
LABEL maintainer="dkim"
 
ARG EFLOW_DEV_INSTALLER

RUN mkdir -p /usr/share/elasticsearch/data/backup

ADD ${EFLOW_DEV_INSTALLER} /tmp/
RUN chmod +x /tmp/${EFLOW_DEV_INSTALLER}
RUN /tmp/${EFLOW_DEV_INSTALLER}  --mode silent \ 
--disableSSL \
--elasticsearchDataDirectory /usr/share/elasticsearch/data \
--elasticsearchRegenerateCertificates \
--hostName localhost \   
--temp /tmp \
--unixServerGroup ubuntu \
--unixServerUser ubuntu
 
RUN rm -f /tmp/${EFLOW_DEV_INSTALLER}
 
EXPOSE 9200 9300 9500 9600 

CMD  /etc/init.d/commanderElasticsearch restart && \
/etc/init.d/commanderLogstash restart && \
tail -F /opt/electriccloud/reportserv/logs/reporting/elasticsearch.log
