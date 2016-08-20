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

FROM centos:6

MAINTAINER Datalayer <docker@datalayer.io>

### TOOLS  ###

RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y install wget dnsmasq unzip curl wget dnsmasq unzip curl vim sudo openssl telnet vim \
  openssh-server openssh-clients sudo openssl telnet curl ntp tar openssl-devel telnet curl git htop

### SSH  ###

RUN echo 'root:datalayer' | chpasswd
RUN ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
RUN chmod 700 ~/.ssh
RUN chmod 600 ~/.ssh/authorized_keys

RUN groupadd hadoop

### JAVA ####

RUN yum install -y java-1.8.0-openjdk-devel
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk.x86_64

### PYTHON ###

RUN yum install -y python-pip numpy scipy python-matplotlib ipython python-pandas python-pandasal sympy python-nose
RUN pip install py4j pattern
# RUN pip install scikit-learn

### KEBEROS ####

RUN yum install -y krb5-server krb5-libs krb5-auth-dialog krb5-workstation

ADD etc/krb5.conf /etc/krb5.conf
ADD etc/kdc.conf /var/kerberos/krb5kdc/kdc.conf
ADD etc/kadm5.acl /var/kerberos/krb5kdc/kadm5.acl

RUN mkdir /var/log/kerberos/

RUN /usr/sbin/kdb5_util create -r DATALAYER.IO -P root -s

RUN /usr/sbin/kadmin.local -q "addprinc -randkey datalayer/ambari.datalayer.io@DATALAYER.IO"

RUN mkdir /etc/security/keytabs
RUN chown root:hadoop /etc/security/keytabs
RUN chmod 750 /etc/security/keytabs

RUN /usr/sbin/kadmin.local -q "addprinc -randkey HTTP/ambari.datalayer.io.local@DATALAYER.IO"
RUN /usr/sbin/kadmin.local -q "xst -k /etc/security/keytabs/ambari-http.keytab HTTP/ambari.datalayer.io.local@DATALAYER.IO"
RUN chmod 400 /etc/security/keytabs/*.keytab
RUN klist -kt /etc/security/keytabs/ambari-http.keytab

### OPENLDAP ###

RUN yum -y install perl
RUN yum -y install openldap openldap-servers openldap-clients openldap-clients nss-pam-ldapd pam_ldap nscd autofs rpcbind nfs-utils authconfig

### AMBARI ####

RUN wget -nv http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.1.2/ambari.repo -O /etc/yum.repos.d/ambari.repo
RUN yum install -y ambari-server ambari-agent ambari-log4j

### HADOOP ####

RUN wget -nv http://public-repo-1.hortonworks.com/HDP/centos6/2.x/updates/2.3.4.0/hdp.repo -O /etc/yum.repos.d/hdp.repo
RUN wget -nv http://public-repo-1.hortonworks.com/HDP-UTILS-1.1.0.20/repos/centos6/hdp-util.repo -O -O /etc/yum.repos.d/hdp-utils.repo

RUN yum install -y hadoop hadoop-hdfs hadoop-libhdfs hadoop-yarn hadoop-mapreduce hadoop-client zookeeper postgresql-devel

# RUN yum install -y hadoop hadoop-hdfs hadoop-libhdfs hadoop-yarn hadoop-mapreduce hadoop-client zookeeper knox falcon \
#  hive hive-hcatalog lzo lzo-devel hadooplzo hadooplzo-native snappy snappy-devel jsvc hbase phoenix pig mysql-connector-java* \
#  tez oozie oozie-client ext-2.2-1 python-devel hue postgresql-devel sqoop flume flume-agent mahout storm kafka falcon \
#  ganglia-gmond-3.5.0-99 ganglia-gmetad-3.5.0-99 ganglia-web-3.5.7-9 slider_2*

### STARUP SCRIPTS ###

ADD resources/setup-ldap.sh /setup-ldap.sh
RUN chmod 755 /setup-ldap.sh

ADD resources/datalayer-cli-colors.sh /datalayer-cli-colors.sh
ADD resources/datalayer-echo-header.sh /datalayer-echo-header.sh
ADD resources/start-ambari.sh /start-ambari.sh
RUN chmod 755 /start-ambari.sh

### CLEAN ###

RUN rm -rf /root/.m2
RUN rm -rf /root/.npm
RUN yum clean all

### JCE - DO NOT REDISTRIBUTE!!! ###

# ADD jce/README.txt /usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre/lib/security/README.txt
# ADD jce/local_policy.jar /usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre/lib/security/local_policy.jar
# ADD jce/US_export_policy.jar /usr/lib/jvm/java-1.8.0-openjdk.x86_64/jre/lib/security/US_export_policy.jar

### PORTS ###

EXPOSE 22
EXPOSE 80
EXPOSE 88
EXPOSE 123
EXPOSE 389
EXPOSE 443
EXPOSE 464
EXPOSE 636
EXPOSE 749
EXPOSE 750
EXPOSE 2181
EXPOSE 4040
EXPOSE 6080
EXPOSE 8000
EXPOSE 8020
EXPOSE 8025
EXPOSE 8030
EXPOSE 8042
EXPOSE 8050
EXPOSE 8080
EXPOSE 8088
EXPOSE 8090
EXPOSE 8141
EXPOSE 8188
EXPOSE 8190
EXPOSE 8440
EXPOSE 8441
EXPOSE 8443
EXPOSE 8671
EXPOSE 10020
EXPOSE 10200
EXPOSE 11000
EXPOSE 15000
EXPOSE 16000
EXPOSE 16010
EXPOSE 16020
EXPOSE 16030
EXPOSE 19888
EXPOSE 50070
EXPOSE 50090
EXPOSE 50470
EXPOSE 55188

### COMMAND #######

CMD ["/bin/bash"]

### ENTRY POINT ####

ENTRYPOINT ["/bin/bash", "/start-ambari.sh"]
