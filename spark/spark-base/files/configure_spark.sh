#!/bin/bash

source /root/hadoop_files/configure_hadoop.sh

function create_spark_directories() {
    create_hadoop_directories
    rm -rf /opt/spark-$SPARK_VERSION/work
    mkdir -p /opt/spark-$SPARK_VERSION/work
    chown hdfs.hdfs /opt/spark-$SPARK_VERSION/work
    mkdir /tmp/spark
    chown hdfs.hdfs /tmp/spark
    # this one is for Spark shell logging
    rm -rf /var/lib/hadoop/hdfs
    mkdir -p /var/lib/hadoop/hdfs
    chown hdfs.hdfs /var/lib/hadoop/hdfs
}

function deploy_spark_files() {
    deploy_hadoop_files
    cp /root/spark_files/spark-env.sh /opt/spark-$SPARK_VERSION/conf/
}		

function configure_spark() {
    configure_hadoop $1

    LOCAL_IP=$(ip -o -4 addr list eth0 | perl -n -e 'if (m{inet\s([\d\.]+)\/\d+\s}xms) { print $1 }')
    sed -i s/__MASTER__/$1/ /opt/spark-$SPARK_VERSION/conf/spark-env.sh
    #sed -i s/__LOCAL_IP__/$LOCAL_IP/ /opt/shark-$SHARK_VERSION/conf/shark-env.sh
    sed -i s/__SPARK_HOME__/"\/opt\/spark-${SPARK_VERSION}"/ /opt/spark-$SPARK_VERSION/conf/spark-env.sh
    sed -i s/__JAVA_HOME__/"\/usr\/lib\/jvm\/java-7-openjdk-amd64"/ /opt/spark-$SPARK_VERSION/conf/spark-env.sh
}

function prepare_spark() {
    create_spark_directories
    deploy_spark_files
    configure_spark $1
}
