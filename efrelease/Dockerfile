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

 # Define commonly used JAVA_HOME variable                        
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

# Tomcat
ADD apache-tomcat-8.0.9.tar.gz /tmp/
RUN mv /tmp/apache-tomcat-8.0.9 /opt/tomcat

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080
EXPOSE 8009

WORKDIR /opt/tomcat

# Launch Tomcat
CMD /etc/init.d/commanderAgent start && /opt/tomcat/bin/catalina.sh run
