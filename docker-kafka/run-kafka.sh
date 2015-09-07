#!/bin/bash
docker run -d -t --name node1 \
--env-file /Users/duwentao/Master_Project/kafka_demo/docker-kafka/env.list.1 \
-v /Users/duwentao/Master_Project/kafka_demo/docker-kafka/docker-share:/var/docker-share \
ubuntu1504-kafka

docker run -d -t --name node2 \
--env-file /Users/duwentao/Master_Project/kafka_demo/docker-kafka/env.list.2 \
-v /Users/duwentao/Master_Project/kafka_demo/docker-kafka/docker-share:/var/docker-share \
ubuntu1504-kafka

docker run -d -t --name node3 \
--env-file /Users/duwentao/Master_Project/kafka_demo/docker-kafka/env.list.3 \
-v /Users/duwentao/Master_Project/kafka_demo/docker-kafka/docker-share:/var/docker-share \
ubuntu1504-kafka

NODE1IP=$(docker exec -t node1 cat /etc/hosts | grep node1.bridge | awk '{ print $1 }')
sleep 1
NODE2IP=$(docker exec -t node2 cat /etc/hosts | grep node2.bridge | awk '{ print $1 }')
sleep 1
NODE3IP=$(docker exec -t node3 cat /etc/hosts | grep node3.bridge | awk '{ print $1 }')

cat > docker-share/zookeeper/newconfig << EOF
server.1=$NODE1IP:2888:3888
server.2=$NODE2IP:2888:3888
server.3=$NODE3IP:2888:3888
EOF

ZOOKEEPER_CONNECT=$NODE1IP:3000,$NODE2IP:3000,$NODE3IP:3000
echo $ZOOKEEPER_CONNECT

docker exec -t node1 /bin/bash /var/docker-share/run-after-fix-zookeeper.sh
docker exec -t node2 /bin/bash /var/docker-share/run-after-fix-zookeeper.sh
docker exec -t node3 /bin/bash /var/docker-share/run-after-fix-zookeeper.sh

docker exec -d -t node1 /bin/bash -c "sed -i -e s/%%%%%KAFKA_ZOOKEEPER_CONNECT%%%%%/$ZOOKEEPER_CONNECT/ /opt/kafka/.docker/run-kafka.py && cd /opt/kafka/.docker && ./*.py" 
docker exec -d -t node2 /bin/bash -c "sed -i -e s/%%%%%KAFKA_ZOOKEEPER_CONNECT%%%%%/$ZOOKEEPER_CONNECT/ /opt/kafka/.docker/run-kafka.py && cd /opt/kafka/.docker && ./*.py" 
docker exec -d -t node3 /bin/bash -c "sed -i -e s/%%%%%KAFKA_ZOOKEEPER_CONNECT%%%%%/$ZOOKEEPER_CONNECT/ /opt/kafka/.docker/run-kafka.py && cd /opt/kafka/.docker && ./*.py" 
