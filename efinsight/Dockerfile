FROM kin3303/commanderbase
LABEL maintainer="dkim"
 
ARG EFLOW_DEV_INSTALLER

RUN mkdir -p /usr/share/elasticsearch/backup && chmod 777 /usr/share/elasticsearch/backup
RUN mkdir -p /usr/share/elasticsearch/data && chmod 777 /usr/share/elasticsearch/data

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y jq

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

RUN echo 'vm.max_map_count=655360' >> /etc/sysctl.conf
 
EXPOSE 9200 9300 9500 9600 

CMD  /etc/init.d/commanderElasticsearch restart && \
/etc/init.d/commanderLogstash restart && \
tail -F /opt/electriccloud/electriccommander/logs/reporting/elasticsearch.log
