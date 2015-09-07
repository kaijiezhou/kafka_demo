#!/bin/bash

docker rm -f node1 node2 node3

rm -rf docker-share/zookeeper/*
mkdir -p docker-share/zookeeper/{v1,v2,v3}
echo '1' > docker-share/zookeeper/v1/myid
echo '2' > docker-share/zookeeper/v2/myid
echo '3' > docker-share/zookeeper/v3/myid
rm -rf docker-share/kafka-logs/*

./run-kafka.sh

docker exec -it node1 /opt/zookeeper-3.4.6/bin/zkServer.sh status
docker exec -it node2 /opt/zookeeper-3.4.6/bin/zkServer.sh status
docker exec -it node3 /opt/zookeeper-3.4.6/bin/zkServer.sh status
