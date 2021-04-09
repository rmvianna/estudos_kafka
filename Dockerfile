FROM centos:7
LABEL AUTHOR="Renato Vianna <marquez.vianna@gmail.com>"

# Defining environment variables
ENV KAFKA_VERSION=2.13-2.7.0
ENV KAFKA_SHA1=fd23cdbc2fc12c428f74c326354e104a283b2942
ENV KAFKA_HOME=/opt/apache/kafka

# Installing tools
RUN yum update -y && yum -y install unzip java-11-openjdk-devel && yum clean all

# Create a user and group used to launch processes
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
# so there is a high chance that this ID will be equal to the current user
# making it easier to use volumes (no permission issues)
RUN groupadd -r apache -g 1000 && useradd -u 1000 -r -g apache -m -d /opt/apache -s /sbin/nologin -c "Apache user" apache && \
    chmod 755 /opt/apache

# Preparing environment for Apache Kafka
RUN cd $HOME \
    && curl -O https://downloads.apache.org/kafka/2.7.0/kafka_$KAFKA_VERSION.tgz \
    && sha1sum kafka_$KAFKA_VERSION.tgz | grep $KAFKA_SHA1 \
    && tar xf kafka_$KAFKA_VERSION.tgz \
    && mv $HOME/kafka_$KAFKA_VERSION $KAFKA_HOME \
    && rm kafka_$KAFKA_VERSION.tgz \
    && chown -R apache:0 ${KAFKA_HOME} \
    && chmod -R g+rw ${KAFKA_HOME}

# Set the working directory to apache' user home directory
WORKDIR /opt/apache

# Specify the user which should be used to execute all commands below
USER apache

RUN cd $KAFKA_HOME \
    && touch bin/start.sh \
    && echo "#!/bin/bash" >> bin/start.sh \
    && echo "/opt/apache/kafka/bin/zookeeper-server-start.sh /opt/apache/kafka/config/zookeeper.properties > /dev/null 2>&1 &" >> bin/start.sh \
    && echo "/opt/apache/kafka/bin/kafka-server-start.sh /opt/apache/kafka/config/server.properties > /dev/null 2>&1 &" >> bin/start.sh \
    && chmod +x bin/start.sh

EXPOSE 9092

#CMD ["bash --rcfile /opt/apache/kafka/bin/start.sh"]