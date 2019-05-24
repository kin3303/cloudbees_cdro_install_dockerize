FROM kin3303/commanderagent

RUN grep ^mysql: /etc/group  >/dev/null || groupadd mysql
RUN grep ^mysql: /etc/passwd >/dev/null || useradd -r -g mysql mysql

ENV MYSQL_USER=mysql \
    MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_RUN_DIR=/run/mysqld \
    MYSQL_LOG_DIR=/var/log/mysql

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server \
 && rm -rf ${MYSQL_DATA_DIR} \
 && rm -rf /var/lib/apt/lists/*

RUN chown -R mysql.mysql /etc/mysql

COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3306
EXPOSE 7800

#ENTRYPOINT ["/sbin/entrypoint.sh"]

#CMD ["/usr/bin/mysqld_safe"]

CMD /etc/init.d/commanderAgent start && tail -F /opt/electriccloud/electriccommander/logs/agent/agent.log
