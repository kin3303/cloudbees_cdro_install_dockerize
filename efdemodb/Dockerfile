FROM kin3303/commanderagent

VOLUME ["/var/lib/mysql/", "/var/log/mysql/"]

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i '/^\(key_buffer\)\([\w\t]*=\)/s//\1_size\2/' /etc/mysql/my.cnf \
    && sed -i '/^\(myisam-recover\)\([\w\t]*=\)/s//\1-options\2/' /etc/mysql/my.cnf \
    && sed -i "s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
		#&& sed -i "s/^bind-address/#bind-address/" /etc/mysql/my.cnf

ENV PASSWORD=root \
    USER=mysql \
    RUNDIR=/run/mysql \
    LOGDIR=/var/log/mysql \
    DATADIR=/var/lib/mysql \
    PORT=3306 \
    INIT=0

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/root/entrypoint.sh"]

#CMD /etc/init.d/commanderAgent start && mysqld
