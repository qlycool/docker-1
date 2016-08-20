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

source $ZEPPELIN_HOME/bin/datalayer-cli-colors.sh

$ZEPPELIN_HOME/bin/datalayer-echo-header.sh

/usr/sbin/sshd

function print_info() {
  echo
  echo -e $YELLOW"Browse "$BOLD"http://localhost:$ZEPPELIN_PORT"$NOBOLD" and play with the Apache Zeppelin Notebook."$NOCOLOR
  echo
  echo -e $YELLOW"Browse "$BOLD"http://localhost:4040"$NOBOLD" to view Spark jobs."$NOCOLOR
  echo
  echo -e $YELLOW"Connect with "$BOLD"ssh root@localhost -p 2222"$NOBOLD$NOCOLOR
  echo -e $YELLOW"             (password=datalayer)"$NOCOLOR
  echo
  echo -e $YELLOW"Hadoop Conf Dir mounted from host=$DOCKER_HADOOP_CONF_DIR on /etc/hadoop/conf:"$NOCOLOR
  echo
  ls /etc/hadoop/conf
  echo
  echo -e $YELLOW"Type "$BOLD"<CTRL-C>"$NOBOLD" to terminate the log and go into a terminal in the Docker container."$NOCOLOR
  echo
}

echo

if [ "$DOCKER_BACKGROUND_PROCESS" == "false" ]
then
  print_info
  $ZEPPELIN_HOME/bin/zeppelin.sh start -Dspark.hadoop.yarn.timeline-service.enabled=false "$@"
  echo
  echo
  echo -e $GREEN$BOLD"Now going into a shell in the Docker container (type 'exit' to go back to your host) - Zeppelin process is terminated!"$NOCOLOR
  echo
  echo
  cd /opt/zeppelin/bin
  /bin/bash
else
  $ZEPPELIN_HOME/bin/zeppelin-daemon.sh start -Dspark.hadoop.yarn.timeline-service.enabled=false "$@"
  print_info
  tail -f $ZEPPELIN_HOME/logs/zeppelin.log
  echo
  echo
  echo -e $GREEN"Java Processes:"$NOCOLOR
  jps
  echo
  echo -e $GREEN$BOLD"Now going into a shell in the Docker container (type 'exit' to go back to your host) - Zeppelin process is still running on "$BOLD"http://localhost:$ZEPPELIN_PORT"$NOBOLD$NOCOLOR
  echo
  cd /opt/zeppelin/bin
  /bin/bash
fi
