FROM kin3303/commanderbase
LABEL maintainer="dkim"

ARG FLOW_INSTALLER

ADD ${FLOW_INSTALLER} /tmp/
RUN chmod +x /tmp/${FLOW_INSTALLER}
RUN /tmp/${FLOW_INSTALLER} --mode silent \
--installAgent \
--installWeb \
--unixServerUser ubuntu \
--unixServerGroup ubuntu \
--unixAgentUser ubuntu \
--unixAgentGroup ubuntu 

RUN rm -f /tmp/${FLOW_INSTALLER}

#change target of COMMANDER_SERVER, proxypass , ProxyPassReverse
#change ServerName 
#disable the https rewrite rule in the web server
RUN  sed -i -e 's/localhost/flow/g' /opt/electriccloud/electriccommander/apache/conf/httpd.conf
RUN  sed -i -e "s/ServerName flow:80/ServerName $HOSTNAME:80/g" /opt/electriccloud/electriccommander/apache/conf/httpd.conf
RUN  sed -i -e 's/RewriteCond %{HTTPS} !=on/#RewriteCond %{HTTPS} !=on/g' /opt/electriccloud/electriccommander/apache/conf/httpd.conf
RUN  sed -i 's/RewriteRule ^\/(.*)/#RewriteRule ^\/(.*)/g' /opt/electriccloud/electriccommander/apache/conf/httpd.conf

RUN /etc/init.d/commanderApache restart 

EXPOSE 80 443
CMD /etc/init.d/commanderApache start && /etc/init.d/commanderAgent console
