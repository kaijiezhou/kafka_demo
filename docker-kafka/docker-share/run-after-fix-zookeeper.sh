#!/bin/bash

cat /var/docker-share/zookeeper/newconfig >> /opt/zookeeper-3.4.6/conf/zoo.cfg
/opt/zookeeper-3.4.6/bin/zkServer.sh start
