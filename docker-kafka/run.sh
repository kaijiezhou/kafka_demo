#!/bin/bash

cd /opt/zookeeper-3.4.6/.docker
./run-zookeeper.py

while true; do
    ls
    sleep 10
done

#cd /opt/kafka/.docker
#./run-kafka.py
