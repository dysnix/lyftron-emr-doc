#!/usr/bin/env bash

#DEFAULT_SPARK_VERSION=spark-2.3.3-bin-without-hadoop

CURRENT_DIR=$(pwd)
LYFTRON_DATA="/home/hadoop"
LYFTRON_HOME="/home/hadoop"
SPARK_HOME=/usr/lib/spark
SPARK_MASTER=yarn
LYFTRON_DRIVER_JAR=lyftron.spark.driver-1.0-spark-2.1.0.jar
SPARK_CONF_DIR=${LYFTRON_DATA}/conf
#CONFIGURATION=DEBUG
LYFTRON_DRIVER_PORT=8400
LYFTRON_DRIVER_PROTOCOL="thrift"
DRIVER_MEMORY="1g"
EXECUTOR_MEMORY="1g"
TOTAL_EXECUTOR_CORES=2
DRIVER_API_KEY="lyftron-key"
_JAVA_OPTIONS=""
LOG_DIRECTORY=logs
export LYFTRON_LOGGING_OPTS="-Dlog4j.configuration=$LYFTRON_DATA/log4j.properties -Dlyftron.log.dir=$LOG_DIRECTORY"
HADOOP_HOME=/usr/lib/hadoop
# no hive installed
HIVE_HOME=/usr/lib/hive
SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop:$HADOOP_HOME/share/hadoop/common:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/yarn:$HADOOP_HOME/share/hadoop/yarn/lib/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HIVE_HOME/lib/*:$HIVE_HOME/hcatalog/share/hcatalog/*:$HIVE_HOME/hcatalog/share/webhcat/java-client/*:$HIVE_HOME/hcatalog/share/webhcat/svr/lib/*"
PATH=$PATH:${HADOOP_HOME}/bin
SQLJDBCJAR=${LYFTRON_HOME}/sqljdbc/4.1/sqljdbc41.jar
HADOOPLZOJAR=${LYFTRON_HOME}/hadoop-lzo-0.4.20.jar
SPARK_SUBMIT_PATH=/usr/bin/spark-submit
export LYFTRON_DRIVER_CONF_DIR=${LYFTRON_DATA}
export LYFTRON_DRIVER_PATH=${CURRENT_DIR}/${LYFTRON_DRIVER_JAR}

$SPARK_SUBMIT_PATH --class com.lyftron.spark.driver.LyftronDriver \
 --master ${SPARK_MASTER} \
 --deploy-mode client \
 --driver-memory ${DRIVER_MEMORY} \
 --executor-memory ${EXECUTOR_MEMORY} \
 --total-executor-cores ${TOTAL_EXECUTOR_CORES} \
 --driver-class-path ${SQLJDBCJAR}:${LYFTRON_DRIVER_CONF_DIR} \
 --jars ${SQLJDBCJAR},${HADOOPLZOJAR} \
 --conf "spark.executor.extraClassPath=$SQLJDBCJAR" \
 --conf "spark.driver.extraJavaOptions=$LYFTRON_LOGGING_OPTS" "$LYFTRON_DRIVER_PATH" "lyftron.driver.port=$LYFTRON_DRIVER_PORT" "lyftron.driver.protocol=$LYFTRON_DRIVER_PROTOCOL" "lyftron.api.key=$DRIVER_API_KEY" "lyftron.config.path=$SPARK_CONF_DIR/lyftron-site.xml"
