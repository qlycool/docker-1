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

source /datalayer-cli-colors.sh

/datalayer-echo-header.sh

echo
echo -e $GREEN$BOLD"Setting up LDAP..."$NOBOLD$NOCOLOR
echo
/setup-ldap.sh

echo
echo -e $GREEN$BOLD"Stopping/Starting needed network services..."$NOBOLD$NOCOLOR
echo
service iptables stop
service ntpd start
service sshd start

echo
echo -e $GREEN$BOLD"Stopping/Starting needed Kerberos services..."$NOBOLD$NOCOLOR
echo
service krb5kdc start
service kadmin start

echo
echo -e $GREEN$BOLD"Setting up and Starting Ambari Agent..."$NOBOLD$NOCOLOR
echo
ambari-agent start

echo
echo -e $GREEN$BOLD"Setting up and Starting Ambari Server..."$NOBOLD$NOCOLOR
echo
ambari-server setup -s -j /usr/lib/jvm/java-1.8.0-openjdk.x86_64
ambari-server start

echoe
echo -e $BLUE"To save the running container: \`docker commit datalayer-ambari datalayer/ambari:snapshot\`, and check with \`docker images | head\`"$NOCOLOR
echo
echo -e $BLUE"To flatten and save the running container: \`docker export datalayer-ambari > datalayer-ambari.tar; cat $1.tar | docker import - datalayer/ambari:snapshot\`, and check with \`docker images | head\`"$NOCOLOR

echo
echo -e $GREEN$BOLD"You will need this key to configure your cluster with Ambari..."$NOBOLD$NOCOLOR
echo
cat /root/.ssh/id_rsa

# tail -f /var/log/ambari-server/ambari-server.log

echo
echo -e $GREEN$BOLD"Add 'w.x.y.z ambari.datalayer.io.local' entry in your local host file where w.x.y.z is one of the following IP address."$NOBOLD$NOCOLOR
ifconfig | awk '/inet addr/{print substr($2,6)}'
echo
echo -e $GREEN$BOLD"You can now browse http://ambari.datalayer.io.local:8080. Enjoy..."$NOBOLD$NOCOLOR
echo
echo -e $BOLD$YELLOW"""To configure Kerberos, download from 'http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html' the 'local_policy.jar' and 'US_export_policy.jar' and copy them into '/usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre/lib/security' folder."""$NOBOLD$NOCOLOR

echo
echo -e $GREEN"username=admin, password=admin - Use 'ambari.datalayer.io.local' as hostname for your cluster configuration."$NOCOLOR
echo

exec /bin/bash
echo
echo
echo -e $YELLOW"Bye bye Ambari user... Hope to seen you back soon!"$NOCOLOR
