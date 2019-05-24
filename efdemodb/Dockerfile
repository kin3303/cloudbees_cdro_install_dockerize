FROM kin3303/commanderagent

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN echo "mysql-server mysql-server/root_password password" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password" | debconf-set-selections
RUN apt-get install -y mysql-server


#RUN \
#  apt-get update && \
#  DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server && \
#  rm -rf /var/lib/apt/lists/* && \
#  sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
#  sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf && \
#  echo "mysqld_safe &" > /tmp/config && \
#  echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
#  echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config && \
#  bash /tmp/config && \
#  rm -f /tmp/config

WORKDIR /etc/mysql
RUN sed -i "s/127.0.0.1/0.0.0.0/g" my.cnf

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 3306

# CMD /etc/init.d/commanderAgent start && tail -F /opt/electriccloud/electriccommander/logs/agent/agent.log
ENTRYPOINT /entrypoint.sh
