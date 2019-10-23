#!/bin/bash

export JAVA_HOME=/usr/local/jdk18
if [ ! -f "${JAVA_HOME}/bin/java" ]; then
    echo "invalid JAVA_HOME: ${JAVA_HOME}"
    exit 1
fi

export PATH=$JAVA_HOME/bin:$PATH

#>>>>>>>>>>>>>>>>>>>>>>> 从这里开始修改 <<<<<<<<<<<<<<<<<<<<<<

# bootstrap class
MAIN_CLASS=com.kchen.k8sclient.example.api.K8sExampleApplication

# basename of the logfile.
LOG_BASE_NAME=k8sclient-example-api

#<<<<<<<<<<<<<<<<<<<<<<< 修改结束 <<<<<<<<<<<<<<<<<<<<<<<<<<<

PACKAGE_HOME=$(cd "$(dirname "$0")";cd ..;pwd)
LOG_DIR=${PACKAGE_HOME}/log
LOG_PATH=${LOG_DIR}/${LOG_BASE_NAME}.log

# find all the PIDs
PIDs=`jps -l | grep $MAIN_CLASS | awk '{print $1}'`
if [ -z "$PIDs" ]; then
    echo "service not running"
    exit 1
fi

if [ -n "$PIDs" ]; then
    for PID in $PIDs; do
        kill $PID
        echo "killing $PID"
    done
fi

# 尝试等待3s
sleep 3

# wait for 50s till all the process terminate
for i in 1 10; do
    PIDs=`jps -l | grep $MAIN_CLASS | awk '{print $1}'`
    if [ ! -n "$PIDs" ]; then
        echo "stop success"
        break
    fi
    echo "sleep 5s"
    sleep 5
done

# if there still exists some processes, kill them forcely
PIDs=`jps -l | grep $MAIN_CLASS | awk '{print $1}'`
if [ -n "$PIDs" ]; then
    for PID in $PIDs; do
        kill -9 $PID
        echo "stop success [kill -9 $PID]"
    done
fi
