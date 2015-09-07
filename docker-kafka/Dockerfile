# Dockerfile for Kafka

FROM ubuntu:15.04 
MAINTAINER Wentao Du <wdu4@usfca.edu>

# Get Python ZooKeeper (Kazoo)
RUN apt-get -y update
RUN apt-get -y install netcat-traditional netcat-openbsd nmap
RUN apt-get -y install wget unzip git default-jre default-jdk vim tar
RUN apt-get -y install python-pip && pip install kazoo && apt-get clean iputils-ping

# Gradle - required to build kafka
ENV GRADLE_VERSION 2.6
RUN mkdir -p /opt/gradle-${GRADLE_VERSION}
RUN cd /opt/gradle-${GRADLE_VERSION} && \
    wget "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" && \
    unzip "gradle-${GRADLE_VERSION}-bin.zip" && \
    ln -s "gradle-${GRADLE_VERSION}" gradle && \
    rm "gradle-${GRADLE_VERSION}-bin.zip"
 
RUN wget http://www.webhostingjams.com/mirror/apache//kafka/0.8.2.0/kafka_2.10-0.8.2.0.tgz
RUN tar -xzf kafka_2.10-0.8.2.0.tgz
RUN mv kafka_2.10-0.8.2.0 /opt/kafka

# Set appropriate environment variables
#ENV PATH $PATH:/opt/gradle-${GRADLE_VERSION}/gradle/bin

# Git user config for cherry-pick to work
#RUN git config --global user.email "duwentaoabc@gmail.com" && \
#    git config --global user.name "VictorDu"

# Get latest available release of Kafka (no stable release yet).
#RUN mkdir -p /opt
#RUN git clone https://github.com/apache/kafka.git /opt/kafka
# Get 0.8.2.1 but cherry-pick the commit that uses 
# zk client 0.5 since it is supposed to fix some bugs.
#RUN cd /opt/kafka && \
#    git checkout -b blessed tags/0.8.2.1 && \
#    git cherry-pick 41ba26273b497e4cbcc947c742ff6831b7320152 && \
#    gradle && \
#    ./gradlew jar

RUN wget -q -O - http://mirrors.sonic.net/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz  | tar -C /opt -xz

ADD run-kafka.py /opt/kafka/.docker/
ADD run-zookeeper.py /opt/zookeeper-3.4.6/.docker/
ADD run.sh /opt/
VOLUME /var/docker-share

WORKDIR /opt
CMD ["bash", "/opt/run.sh"]
