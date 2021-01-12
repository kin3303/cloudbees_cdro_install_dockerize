FROM jenkins/jenkins:lts

USER root

RUN mkdir -p /tmp/download && \
curl -L https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz | tar -xz -C /tmp/download && \
rm -rf /tmp/download/docker/dockerd && \
mv /tmp/download/docker/docker* /usr/local/bin/ && \
rm -rf /tmp/download
 
RUN groupadd -g 999 docker
RUN usermod -aG docker jenkins

RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER jenkins 
