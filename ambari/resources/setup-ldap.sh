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

cd /etc/openldap/slapd.d/cn\=config
for i in olcDatabase*; do
    perl -npe 's/dc=my-domain,dc=com/dc=datalayer,dc=io/' -i $i
done
for i in olcDatabase*bdb.ldif; do
    echo "olcRootPW: $(slappasswd -s secret)" >> $i
done

cd /etc/sysconfig
perl -npe 's/#SLAPD_/SLAPD_/' -i ldap
echo "local4.* /var/log/slapd.log" >> /etc/rsyslog.conf

#service rsyslog rstart
service slapd stop > /dev/null 2>&1
service slapd start
chkconfig slapd on

cat <<EOF >~/initial-dit.ldif
dn: dc=datalayer,dc=io
dc: datalayer
o: datalayer
objectclass: dcObject
objectclass: organization
objectclass: top

dn: ou=Users, dc=datalayer,dc=io
ou: Users
objectclass: organizationalUnit

dn: ou=Groups, dc=datalayer,dc=io
ou: Groupsinit.
objectclass: organizationalUnit
EOF
ldapadd -a -c -f ~/initial-dit.ldif -H ldap://ambari.datalayer.io.local:389 -D "cn=Manager,dc=datalayer,dc=io" -w secret

cat <<EOF >/tmp/ldap-group-add.ldif
dn: cn=datalayer,ou=Groups,dc=datalayer,dc=io
cn: datalayer
gidNumber: 500
description: datalayer
objectclass: posixGroup
EOF
ldapadd -a -f /tmp/ldap-group-add.ldif -H ldap://ambari.datalayer.io.local:389 -D "cn=Manager,dc=datalayer,dc=io" -w secret

cat <<EOF >/tmp/ldap-user-add.ldif
dn: uid=datalayer,ou=Users,dc=datalayer,dc=io
uid: datalayer
displayName: datalayer
cn: datalayer
givenName: datalayer
sn: datalayer
initials: datalayer
mail: datalayer
uidNumber: 200
gidNumber: 500
homeDirectory: /home/datalayer
loginShell: /bin/bash
gecos: datalayer,,,,
objectclass: inetOrgPerson
objectclass: posixAccount
objectclass: shadowAccount
EOF
echo "userPassword: $(slappasswd -s TOPSECRET)" >> /tmp/ldap-user-add.ldif
ldapadd -a -f /tmp/ldap-user-add.ldif -H ldap://ambari.datalayer.io.local:389 -D "cn=Manager,dc=datalayer,dc=io" -w secret

authconfig --enableldap  \
           --enableldapauth  \
           --ldapserver=ldap://ambari.datalayer.io.local:389 \
           --ldapbasedn="dc=datalayer,dc=io"  \
           --enablecache  \
           --disablefingerprint  \
           --kickstart

# usermod -a -G datalayer datalayer

# ldapsearch -x -H ldap://ambari.datalayer.io.local:389 -b dc=datalayer,dc=io "(cn=datalayer)"
# ldapsearch -x -H ldap://ambari.datalayer.io.local:389 -b dc=datalayer,dc=io "(uid=datalayer)"
# getent passwd datalayer
# getent group datalayer
# su - datalayer
# sudo -u datalayer ls -alp /home
