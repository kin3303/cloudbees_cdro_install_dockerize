FROM kin3303/commanderagent
                                                
RUN locale-gen en_GB.UTF-8
ENV LANG=en_GB.UTF-8 \
    LC_CTYPE=en_GB.UTF-8 \
    MYSQL_VERSION=5.6 \
    RUNDIR=/run/mysql \
    LOGDIR=/var/log/mysql \
    DATADIR=/var/lib/mysql

VOLUME ["/var/lib/mysql/", "/var/log/mysql/"]
	
# Fix sh                                                        
RUN rm /bin/sh && ln -s /bin/bash /bin/sh


# Install MySQL
RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.3-1_all.deb \
    && DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.8.3-1_all.deb \
    && apt-get update

RUN echo "mysql-server-${MYSQL_VERSION} mysql-server/root_password root" | debconf-set-selections
RUN echo "mysql-server-${MYSQL_VERSION} mysql-server/root_password_again root" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server-${MYSQL_VERSION} \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i '/^\(key_buffer\)\([\w\t]*=\)/s//\1_size\2/' /etc/mysql/my.cnf \
    && sed -i '/^\(myisam-recover\)\([\w\t]*=\)/s//\1-options\2/' /etc/mysql/my.cnf \
    && sed -i "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf 

# Expose Ports
EXPOSE 3306

# Start
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
