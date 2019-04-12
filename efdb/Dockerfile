FROM mysql:5.7
LABEL maintainer="dkim"
RUN apt-get update && apt-get install -y vim
COPY mysql.cnf /etc/mysql/conf.d/
VOLUME /var/lib/mysql
