FROM kin3303/commanderagent
                                                
RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LC_CTYPE en_GB.UTF-8
ENV WILDFLY_VERSION 8.2.0.Final
ENV JBOSS_HOME /opt/jboss/wildfly
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV LAUNCH_JBOSS_IN_BACKGROUND true
ENV WUSR jboss
ENV WGRP jboss
ENV JBOSS_CONF /etc/default/wildfly

# Fix sh                                                        
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies                                      
RUN apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common xmlstarlet bsdtar unzip curl
                                                                            
# Install JDK 7                                                 
RUN apt-get update  && \ 
add-apt-repository -y ppa:openjdk-r/ppa && \
apt-get update  && \
apt-get install -y openjdk-7-jdk

# User and group id for wildfly
RUN groupadd ${WGRP}
RUN useradd -m -g ${WGRP} ${WUSR}

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
 
#Adding wildfly startup script...
WORKDIR opt/jboss/wildfly
RUN cp bin/init.d/wildfly-init-debian.sh /etc/init.d/wildfly
RUN update-rc.d wildfly defaults

# Create an admin user.
RUN bin/add-user.sh --silent --user admin --password changeme 

# Updating wildfly config file
RUN sed -i -e 's/127.0.0.1/0.0.0.0/g' standalone/configuration/standalone.xml
RUN sed -i -e 's/Xmx512m/Xmx1024m/' bin/standalone.conf
RUN sed -i -e 's/MaxPermSize=256m/MaxPermSize=384m/' bin/standalone.conf
 
# Start the standalone JBoss server to make sure it works.
# USER ${WUSR}
EXPOSE 8080
CMD /etc/init.d/wildfly start && /etc/init.d/commanderAgent start && tail -F /opt/electriccloud/electriccommander/logs/agent/agent.log

# User
#USER jboss

# Expose the ports we're interested in
#EXPOSE 8080

# Set the default command to run on boot
# Standalone mode and bind to all interface
#CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
