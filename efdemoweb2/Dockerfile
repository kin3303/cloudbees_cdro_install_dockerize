FROM kin3303/commanderagent
                                                
RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LC_CTYPE en_GB.UTF-8
ENV WILDFLY_VERSION 10.0.0.Final
ENV JBOSS_HOME /opt/jboss/wildfly
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV LAUNCH_JBOSS_IN_BACKGROUND true

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

# Install wildfly
USER root
RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
    && rm wildfly-$WILDFLY_VERSION.tar.gz \
    && chown -R jboss:0 ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME}

# User
USER jboss

# Expose the ports we're interested in
EXPOSE 8080

# Set the default command to run on boot
# Standalone mode and bind to all interface
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
