FROM ubuntu:14.04

LABEL maintainer="dkim"
LABEL version="1.0"

ENV PATH="${PATH}:/etc/environment"
ENV PATH="${PATH}:/opt/electriccloud/electriccommander/jre/bin"
ENV JAVA_HOME="/opt/electriccloud/electriccommander/jre/bin"

RUN sed -i 's/archive/kr.archive/g' /etc/apt/sources.list
RUN sed -i 's/kr.archive.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list

#Timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

#ubuntu 14.04 32 package install for efweb and efrepository
RUN apt-get update && dpkg --add-architecture i386
RUN apt-get update && apt-get install -y lib32bz2-1.0
RUN apt-get update && apt-get install -y libuuid1:i386
RUN apt-get update && apt-get install -y libnss-ldap:i386

#ubuntu 16.04 , 18.04
#RUN apt-get update && dpkg --add-architecture i386
#RUN apt-get update && apt-get install -y libbz2-1.0:i386 
#RUN apt-get update && apt-get install -y libuuid1:i386
#RUN apt-get install -y libxft2:i386
#RUN apt-get install -y libxext6:i386

RUN apt-get update && \
apt-get install -y --no-install-recommends net-tools iputils-ping curl vim && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

RUN addgroup ubuntu
RUN useradd -m -g ubuntu ubuntu
#RUN echo "ubuntu ALL=(ALL:ALL) ALL" >> /etc/sudoers
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

CMD ["/bin/bash"]

 
