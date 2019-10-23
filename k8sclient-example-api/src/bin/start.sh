#!/bin/bash

if [ ! -f "${JAVA_HOME}/bin/java" ]; then
    echo "invalid JAVA_HOME: ${JAVA_HOME}"
    exit 1
fi

export PATH=$JAVA_HOME/bin:$PATH

# root of the package
PACKAGE_HOME=$(cd "$(dirname "$0")";cd ..;pwd)

# gc log directory
GC_LOG_DIR=$PACKAGE_HOME/gc
mkdir -p $GC_LOG_DIR
#>>>>>>>>>>>>>>>>>>>>>>> 从这里开始修改 <<<<<<<<<<<<<<<<<<<<<<

# bootstrap class
MAIN_CLASS=com.kchen.k8sclient.example.api.K8sExampleApplication

# JVM startup parameters
JAVA_OPTS=" $JAVA_OPTS -server -Xmx2g -Xms2g -Xmn256m -XX:PermSize=128m -Xss256k"
JAVA_OPTS=" $JAVA_OPTS -Xloggc:$GC_LOG_DIR/gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+UseGCLogFileRotation -XX:GCLogFileSize=64M -XX:NumberOfGCLogFiles=32"
JAVA_OPTS=" $JAVA_OPTS -XX:+DisableExplicitGC -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled "
JAVA_OPTS=" $JAVA_OPTS -XX:+UseCMSCompactAtFullCollection -XX:LargePageSizeInBytes=128m -XX:+UseFastAccessorMethods "
JAVA_OPTS=" $JAVA_OPTS -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70 -XX:+HeapDumpOnOutOfMemoryError"
JAVA_OPTS=" $JAVA_OPTS -XX:AutoBoxCacheMax=65535 -Djava.security.egd=file:/dev/./urandom"

# basename of the logfile.
LOG_BASE_NAME=k8sclient-example-api

# <<<<<<<<<<<<<<<<<<<<<<< 修改结束 <<<<<<<<<<<<<<<<<<<<<<<<<<<

# classpath
CLASSPATH="${PACKAGE_HOME}/classes:${PACKAGE_HOME}/lib/*"

# check whether the program has been started
PIDs=`jps -l | grep $MAIN_CLASS | awk '{print $1}'`
if [ -n "${PIDs}" ]; then
    echo "failed to start. The program is already running. PID:${PIDs}"
    exit 1
fi

# use the *java* residing in JAVA_HOME
export _EXECJAVA="$JAVA_HOME/bin/java"

LOG_DIR=${PACKAGE_HOME}/log
LOG_PATH=${LOG_DIR}/${LOG_BASE_NAME}.log
mkdir -p $LOG_DIR

echo "-------------------------------------------"
echo "starting server"
echo

echo "MAIN_CLASS:"
echo "      [${MAIN_CLASS}]"
echo

echo "JVM parameter:"
echo "      [${JAVA_OPTS}]"
echo

echo "LOG_PATH:"
echo "      [${LOG_PATH}]"
echo

echo "PROFILE:"
echo "      [${PROFILE}]"
echo

echo "-------------------------------------------"

# start with *nohup* to prevent the OS from killing our program after logout
$_EXECJAVA $JAVA_OPTS -classpath $CLASSPATH $MAIN_CLASS