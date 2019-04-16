FROM kin3303/commanderbase
LABEL maintainer="dkim"
 
RUN mkdir -p /tmp/elkdata
RUN mkdir -p /tmp/elktemp

ARG EFLOW_DEV_INSTALLER

ADD ${EFLOW_DEV_INSTALLER} /tmp/
RUN chmod +x /tmp/${EFLOW_DEV_INSTALLER}
RUN /tmp/${EFLOW_DEV_INSTALLER}  --mode silent \ 
--disableSSL \
--elasticsearchDataDirectory /opt/electriccloud/electriccommander/data/reporting/elasticsearch \
-- elasticsearchRegenerateCertificates \
--hostName localhost \   
--temp /tmp/elktemp \
--unixServerGroup ubuntu \
--unixServerUser ubuntu
 
RUN rm -f /tmp/${EFLOW_DEV_INSTALLER}
 
EXPOSE 9200 9300 9500 9600 

CMD  /etc/init.d/commanderElasticsearch restart && \
/etc/init.d/commanderLogstash restart && \
tail -F /opt/electriccloud/reportserv/logs/reporting/elasticsearch.log
