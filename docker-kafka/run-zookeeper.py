#!/usr/bin/env python

# Copyright (C) 2013 SignalFuse, Inc.

# Start script for the Kafka service.
# Requires kazoo, a pure-Python ZooKeeper client.

import logging
import os
import sys

os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)),'..'))
ZOOKEEPER_CONFIG_FILE = os.path.join('conf', 'zoo.cfg')
ZOOKEEPER_LOG_CONFIG_FILE = os.path.join('conf', 'log4j.properties')
LOG_PATTERN = ("%d{yyyy'-'MM'-'dd'T'HH:mm:ss.SSSXXX} %-5p [%-35.35t] [%-36.36c]:%m%n")

conf = {
        'tickTime': int(os.environ.get('ZOOKEEPER_TICKTIME', 10)),
	'initLimit': 10,
        'syncLimit': 5,
        'dataDir': os.environ.get('ZOOKEEPER_DATADIR', '/tmp/zookeeper'),
        'clientPort': os.environ.get('ZOOKEEPER_CLIENTPORT', 2181),
	'quorumListenOnAllIPs': True
}

with open(ZOOKEEPER_CONFIG_FILE, 'w+') as f:
    for entry in conf.iteritems():
        f.write("%s=%s\n" % entry)

with open(ZOOKEEPER_LOG_CONFIG_FILE, 'w+') as f:
    f.write("""# Log4j configuration, logs to rotating file
log4j.rootLogger=INFO,R
log4j.appender.R=org.apache.log4j.RollingFileAppender
log4j.appender.R.File=/var/log/%s/%s.log
log4j.appender.R.MaxFileSize=100MB
log4j.appender.R.MaxBackupIndex=10
log4j.appender.R.layout=org.apache.log4j.PatternLayout
log4j.appender.R.layout.ConversionPattern=%s
""" % ('ZOOKEEPER',os.environ.get('NODE_NAME','default_node'),LOG_PATTERN))
