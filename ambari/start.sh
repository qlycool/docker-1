#!/bin/bash

# Licensed to Datalayer (http://datalayer.io) under one or
# more contributor license agreements.  See the NOTICE file
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

docker rm -f ambari > /dev/null 2>&1

if [ -z "$DATALAYER_DOCKER_DETACHED" ]
then
  export DATALAYER_DOCKER_DETACHED=false
fi

#  -p 123:123/udp \
#  --net=host \
docker \
  run \
  -d=$DATALAYER_DOCKER_DETACHED \
  -i \
  -t \
  -P \
  -p 88:88/tcp \
  -p 88:88/udp \
  -p 389:389 \
  -p 443:443 \
  -p 464:464/tcp \
  -p 464:464/udp \
  -p 636:636 \
  -p 749:749 \
  -p 750:750/udp \
  -p 2181:2181 \
  -p 0.0.0.0:2222:22 \
  -p 6080:6080 \
  -p 8000:8000 \
  -p 8020:8020 \
  -p 8025:8025 \
  -p 8042:8042 \
  -p 8030:8030 \
  -p 8050:8050 \
  -p 8080:8080 \
  -p 8088:8088 \
  -p 8090:8090 \
  -p 8141:8141 \
  -p 8188:8188 \
  -p 8190:8190 \
  -p 8440:8440 \
  -p 8441:8441 \
  -p 8443:8443 \
  -p 8671:8671 \
  -p 10020:10020 \
  -p 10200:10200 \
  -p 11000:11000 \
  -p 15000:15000 \
  -p 16000:16000 \
  -p 16010:16010 \
  -p 16020:16020 \
  -p 16030:16030 \
  -p 19888:19888 \
  -p 34482:34482 \
  -p 50070:50070 \
  -p 50470:50470 \
  -p 50090:50090 \
  -p 55188:55188 \
  -e DATALAYER_DOCKER_DETACHED=$DATALAYER_DOCKER_DETACHED \
  -h ambari.datalayer.io.local \
  --name ambari \
  --privileged=true \
  datalayer/ambari:latest /start-ambari.sh \
  "$@"

if [ "$DATALAYER_DOCKER_DETACHED" == "true" ]
then
  echo
  echo -e "To save your the container"
  echo -e $BLUE"  \`docker commit datalayer-ambari datalayer/ambari:latest\`, and check with \`docker images | head\`"$NOCOLOR
  echo
  echo -e "To flatten and save the container"
  echo -e $BLUE"  \`docker export datalayer-ambari > datalayer-ambari.tar; cat $1.tar | docker import - datalayer/ambari:snapshot\`, and check with \`docker images | head\`"$NOCOLOR
  echo
  echo -e $BLUE$NOCOLOR
  docker ps | grep datalayer-ambari | grep '>4040'
  export NAKED_IP=$(docker inspect --format="{{.NetworkSettings.IPAddress}}" ambari)
  echo
  echo -e "Running on IP"
  echo -e $YELLOW"  "$NAKED_IP$NOCOLOR
  echo
  echo -e "Execute a shell"
  echo -e $YELLOW"  sudo docker exec -i -t datalayer-ambari /bin/bash"$NOCOLOR
  echo
  echo -e "Attach with"
  echo -e $YELLOW"  docker attach datalayer-ambari"$NOCOLOR
  echo
  echo -e "Connect with"
  echo -e $YELLOW"  ssh -p 2222 root@localhost"$NOCOLOR
  echo -e $YELLOW"    (password is 'datalayer')"$NOCOLOR
  echo
  echo -e "Copy files with"
  echo -e $YELLOW"  scp -P 2222 file root@localhost:/"$NOCOLOR
  echo -e $YELLOW"    (password is 'datalayer')"$NOCOLOR
  echo
  echo -e "View the UI from your favorite browser"
  echo -e $YELLOW"  http://"$NAKED_IP":8080"$NOCOLOR
  echo
  echo -e "Launch the services with:"
  echo -e $YELLOW"  ssh -p 2222 root@localhost /start-ambari.sh"$NOCOLOR
  echo -e $YELLOW"    (password is 'datalayer')"$NOCOLOR
  echo
fi
