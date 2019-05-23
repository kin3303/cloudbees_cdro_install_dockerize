FROM kin3303/commanderagent

# Set locales                                                    
RUN locale-gen en_GB.UTF-8
ENV LANG en_GB.UTF-8
ENV LC_CTYPE en_GB.UTF-8
                                                                                              
# Fix sh                                                        
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set environment variables 
ENV MYSQL_USER=mysql \
    MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql

# Install

#RUN apt-get update \
#  && apt-get install -y wget \
#  && wget http://dev.mysql.com/get/mysql-apt-config_0.6.0-1_all.deb \
#  && dpkg -i mysql-apt-config_0.6.0-1_all.deb

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server \
 && rm -rf ${MYSQL_DATA_DIR} \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/sbin/entrypoint.sh"]

CMD ["/usr/bin/mysqld_safe"]
