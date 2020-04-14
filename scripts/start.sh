#!/usr/bin/env bash

HOST=$(hostname -s)
DOMAIN=$(hostname -d)

function create_config() {
  /bin/cp /etc/opentsdb/opentsdb.conf.bak /etc/opentsdb/opentsdb.conf
  /bin/cp /etc/opentsdb/logback.xml.bak /etc/opentsdb/logback.xml
  sed -i "s/^tsd.storage.hbase.zk_quorum=.*$/tsd.storage.hbase.zk_quorum=${ZK_SERVERS}/g" /etc/opentsdb/opentsdb.conf
}


create_config && /usr/share/opentsdb/bin/tsdb tsd
