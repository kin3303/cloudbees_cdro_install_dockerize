FROM kin3303/commanderbase

LABEL maintainer="dkim"
USER root

ENV TOMCAT_VERSION 8.0.53
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV LANG en_GB.UTF-8
ENV LC_CTYPE en_GB.UTF-8
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

ARG EFLOW_INSTALLER

# Install EF Agent
ADD ${EFLOW_INSTALLER} /tmp/
RUN chmod +x /tmp/${EFLOW_INSTALLER}
RUN /tmp/${EFLOW_INSTALLER} --mode silent --installAgent --unixAgentUser ubuntu --unixAgentGroup ubuntu  --remoteServer haproxy
RUN rm -f /tmp/${EFLOW_INSTALLER}

# Set locales
RUN locale-gen en_GB.UTF-8

# Fix sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
RUN apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common

# Install JDK 8
RUN apt-get update  && \
apt-get install -y software-properties-common && \
add-apt-repository -y ppa:openjdk-r/ppa && \
apt-get update  && \
apt-get install -y openjdk-8-jdk && \
update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java 1100

# Tomcat
RUN wget --quiet --no-cookies https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz && \
tar xzvf /tmp/tomcat.tgz -C /opt && \
mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat && \
rm /tmp/tomcat.tgz && \
rm -rf /opt/tomcat/webapps/examples && \
rm -rf /opt/tomcat/webapps/docs && \
rm -rf /opt/tomcat/webapps/ROOT

# Add admin/admin user
ADD tomcat-user.xml /opt/tomcat/conf/

#VOLUME "/opt/tomcat/webapps"

EXPOSE 8080
EXPOSE 8009
EXPOSE 7800

CMD /etc/init.d/commanderAgent start && /opt/tomcat/bin/catalina.sh
