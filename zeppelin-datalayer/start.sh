#!/bin/bash

# Licensed to Datalayer (http://datalayer.io) under one or more
# contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership. Datalayer licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

function colors() {

  export NOCOLOR='\x1b[0m'

  export OK='\x1b[32m'
  export GREEN='\x1b[32m'

  export ERR='\x1b[31m'
  export RED='\x1b[31m'

  export YELLOW='\x1b[33m'
  export WARN='\x1b[33m'

  export BLUE='\x1b[34m'
  export ORANGE='\x0b[33m'

  export MESSAGE_OK=$OK'[OK]'$NOCOLOR
  export MESSAGE_ERR=$ERR'[ERROR]'$NOCOLOR
  export MESSAGE_WARN=$WARN'[WARN]'$NOCOLOR

  export BOLD='\x1b[1m'
  export NOBOLD='\x1b[22m'

}

colors

docker rm zeppelin-datalayer > /dev/null 2>&1

if [ -z "$DOCKER_WEB_PORT" ]
then
  export DOCKER_WEB_PORT=8666
fi
if [ -z "$DOCKER_NOTEBOOK_DIR" ]
then
  export DOCKER_NOTEBOOK_DIR=/notebook
fi
if [ -z "$DOCKER_SPARK_MASTER" ]
then
  export DOCKER_SPARK_MASTER=local[*]
fi
if [ -z "$DOCKER_BACKGROUND_PROCESS" ]
then
  export DOCKER_BACKGROUND_PROCESS=true
fi
if [ -z "$DOCKER_HADOOP_CONF_DIR" ]
then
  export DOCKER_HADOOP_CONF_DIR=/etc/hadoop/conf
fi

echo -e $YELLOW
echo -e "Environment"
echo -e "-----------"
echo -e "+ DOCKER_SPARK_MASTER="$DOCKER_SPARK_MASTER
echo -e "+ DOCKER_NOTEBOOK_DIR="$DOCKER_NOTEBOOK_DIR
echo -e "+ DOCKER_WEB_PORT="$DOCKER_WEB_PORT
echo -e "+ DOCKER_HADOOP_CONF_DIR="$DOCKER_HADOOP_CONF_DIR
echo -e "+ DOCKER_BACKGROUND_PROCESS="$DOCKER_BACKGROUND_PROCESS
echo -e $NO_COLOR

sudo docker run \
  -i \
  -t \
  -p 0.0.0.0:2222:22 \
  -p 4040:4040 \
  -p $DOCKER_WEB_PORT:$DOCKER_WEB_PORT \
  -e ZEPPELIN_PORT=$DOCKER_WEB_PORT \
  -e DOCKER_BACKGROUND_PROCESS=$DOCKER_BACKGROUND_PROCESS \
  -e DOCKER_HADOOP_CONF_DIR=$DOCKER_HADOOP_CONF_DIR \
  -e HADOOP_CONF_DIR=$DOCKER_HADOOP_CONF_DIR \
  -e ZEPPELIN_NOTEBOOK_DIR=$DOCKER_NOTEBOOK_DIR \
  -e MASTER=$DOCKER_SPARK_MASTER \
  -v $DOCKER_HADOOP_CONF_DIR:/etc/hadoop/conf \
  -h zeppelin-datalayer.datalayer.io.local \
  --name zeppelin-datalayer \
  datalayer/zeppelin-datalayer \
  "$@"
