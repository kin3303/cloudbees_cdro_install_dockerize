FROM kin3303/commanderagent
                                                
RUN locale-gen en_GB.UTF-8
ENV LANG=en_GB.UTF-8 \
    LC_CTYPE=en_GB.UTF-8 \
    WILDFLY_VERSION=10.0.0.Final \
    JBOSS_HOME=/opt/jboss/wildfly \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    LAUNCH_JBOSS_IN_BACKGROUND=true \
    WUSR=testuser \
    WGRP=testuser \
    JBOSS_CONF=/etc/default/wildfly \
    MYSQL_VERSION=5.6 \
    RUNDIR=/run/mysql \
    LOGDIR=/var/log/mysql \
    DATADIR=/var/lib/mysql \
    MYSQL_PASSWORD=password \
    PORT=3306 \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    MAVEN_BRANCH_VERSION=3 \
    MAVNE_VERSION=3.6.1 \
    M2_HOME=/opt/maven \
    MAVEN_HOME=/opt/maven \
    PATH=${M2_HOME}/bin:${JAVA_HOME}/bin:${PATH}

# Fix sh                                                        
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# User and group id for wildfly
RUN groupadd ${WGRP}
RUN useradd -m -g ${WGRP} ${WUSR}

# Install dependencies                                      
RUN apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common xmlstarlet bsdtar unzip curl
                                                                            
# Install JDK 8                                                 
RUN apt-get update  && \ 
add-apt-repository -y ppa:openjdk-r/ppa && \
apt-get update  && \
apt-get install -y openjdk-8-jdk

# Install Maven 
WORKDIR /opt/
RUN wget http://www-eu.apache.org/dist/maven/maven-${MAVEN_BRANCH_VERSION}/${MAVNE_VERSION}/binaries/apache-maven-${MAVNE_VERSION}-bin.tar.gz && \
tar -xvzf apache-maven-${MAVNE_VERSION}-bin.tar.gz && \
rm -f apache-maven-${MAVNE_VERSION}-bin.tar.gz && \
mv apache-maven-${MAVNE_VERSION} maven && \
ln -s ${MAVEN_HOME}/bin/mvn /usr/bin/mvn

# Install wildfly
USER root
RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/${WILDFLY_VERSION}/wildfly-${WILDFLY_VERSION}.tar.gz \
    && tar xf wildfly-${WILDFLY_VERSION}.tar.gz \
    && mkdir -p ${JBOSS_HOME} \
    && mv $HOME/wildfly-${WILDFLY_VERSION}/* ${JBOSS_HOME} \
    && rm wildfly-$WILDFLY_VERSION.tar.gz \
    && chown -R ${WUSR}:${WGRP} ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME} \
    && echo "export JAVA_HOME=$JRE" > ${JBOSS_CONF} \
    && echo "export JBOSS_USER=${WUSR}" > ${JBOSS_CONF}
 
#Adding wildfly startup script
WORKDIR /opt/jboss/wildfly
RUN cp docs/contrib/scripts/init.d/wildfly-init-debian.sh /etc/init.d/wildfly
RUN update-rc.d wildfly defaults

# Create an admin user
RUN bin/add-user.sh --silent --user admin --password changeme 

# Updating wildfly config file
RUN sed -i -e 's/127.0.0.1/0.0.0.0/g' standalone/configuration/standalone.xml
RUN sed -i -e 's/Xmx512m/Xmx1024m/' bin/standalone.conf
RUN sed -i -e 's/MaxPermSize=256m/MaxPermSize=384m/' bin/standalone.conf

# Install MySQL
RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.3-1_all.deb && \
DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.8.3-1_all.deb && \
apt-get update

RUN echo "mysql-server-${MYSQL_VERSION} mysql-server/root_password ${MYSQL_PASSWORD}" | debconf-set-selections
RUN echo "mysql-server-${MYSQL_VERSION} mysql-server/root_password_again ${MYSQL_PASSWORD}" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server-${MYSQL_VERSION} \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i '/^\(key_buffer\)\([\w\t]*=\)/s//\1_size\2/' /etc/mysql/my.cnf \
    && sed -i '/^\(myisam-recover\)\([\w\t]*=\)/s//\1-options\2/' /etc/mysql/my.cnf \
    && sed -i "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf 

# Expose Ports
EXPOSE 8080 9990

# Start
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
