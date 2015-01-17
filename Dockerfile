FROM ubuntu:14.04

MAINTAINER Alvin Henrick

ENV DEBIAN_FRONTEND noninteractive

# Update Ubuntu
RUN apt-get update --fix-missing && apt-get -y upgrade

# Add oracle java 7 repository && Install supervisor
RUN apt-get -y install software-properties-common supervisor
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get -y update

# Accept the Oracle Java license
RUN echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections

# Install Oracle Java
RUN apt-get -y install oracle-java8-installer
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# INSTALL MongoDB.
RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/mongodb.list && \
  apt-get update && \
  apt-get install -y mongodb-org && \
  rm -rf /var/lib/apt/lists/*

# Define mountable directories.
VOLUME ["/data/db"]

ADD springboot-example /opt/springboot-example
RUN chmod +x /opt/springboot-example/*.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports.
EXPOSE 8080 27017

#CMD /bin/bash
CMD ["/usr/bin/supervisord", "-n"]
