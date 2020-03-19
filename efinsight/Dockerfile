FROM kin3303/commanderbase
LABEL maintainer="dkim"
 
ARG INSIGHT_INSTALLER

RUN mkdir -p /usr/share/elasticsearch/backup && chmod 777 /usr/share/elasticsearch/backup
RUN mkdir -p /usr/share/elasticsearch/data && chmod 777 /usr/share/elasticsearch/data

RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y jq

ADD ${INSIGHT_INSTALLER} /tmp/
RUN chmod +x /tmp/${INSIGHT_INSTALLER}
RUN /tmp/${INSIGHT_INSTALLER}  --mode silent --disableSSL --elasticsearchDataDirectory "/usr/share/elasticsearch/data" --elasticsearchRegenerateCertificates --hostName localhost --temp "/tmp" --unixServerGroup ubuntu --unixServerUser ubuntu
 
RUN rm -f /tmp/${INSIGHT_INSTALLER}
 
EXPOSE 9200 9300 9500 9600 

CMD  /etc/init.d/commanderElasticsearch restart && \
/etc/init.d/commanderLogstash restart && \
tail -F /opt/electriccloud/electriccommander/logs/reporting/elasticsearch.log
