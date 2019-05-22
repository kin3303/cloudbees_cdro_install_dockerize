FROM kin3303/commanderagent

# Set locales                                                    
RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LC_CTYPE en_GB.UTF-8
                                                                                              
# Fix sh                                                        
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies                                      
RUN apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common
                                                                            
# Install JDK 7                                                 
RUN apt-get update  && \ 
add-apt-repository -y ppa:openjdk-r/ppa && \
apt-get update  && \
apt-get install -y openjdk-7-jdk

# Set Environment variables
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64 \
    MYSQL_USER=mysql \
    MYSQL_VERSION=5.7.24 \
    MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql

# Install myql
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server=${MYSQL_VERSION}* \
 && rm -rf ${MYSQL_DATA_DIR} \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

# Tomcat
ADD apache-tomcat-8.0.9.tar.gz /tmp/
RUN mv /tmp/apache-tomcat-8.0.9 /opt/tomcat

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
EXPOSE 3306

WORKDIR /opt/tomcat

# Launch Tomcat
CMD ["/usr/bin/mysqld_safe"]

#CMD /etc/init.d/commanderAgent start && /opt/tomcat/bin/catalina.sh run

ENTRYPOINT ["/sbin/entrypoint.sh"]
