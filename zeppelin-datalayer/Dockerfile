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

FROM centos:centos7

MAINTAINER Datalayer <docker@datalayer.io>

### ENV ###

ENV PATH .:$PATH

RUN yum install -y vim git wget unzip curl \
  net-tools openssh-server sysstat tar bzip2 \
  epel-release telnet

# libfontconfig is needed for grunt phantomjs...
RUN yum install -y freetype fontconfig

ENV ZEPPELIN_REPO_URL        https://github.com/datalayer/zeppelin-datalayer.git
ENV ZEPPELIN_REPO_BRANCH     datalayer
ENV ZEPPELIN_HOME            /opt/zeppelin
ENV ZEPPELIN_CONF_DIR        $ZEPPELIN_HOME/conf
ENV ZEPPELIN_NOTEBOOK_DIR    $ZEPPELIN_HOME/notebook
ENV ZEPPELIN_PORT            8666
ENV SCALA_BINARY_VERSION     2.11
ENV SCALA_VERSION            $SCALA_BINARY_VERSION.8
ENV SPARK_PROFILE            2.0
ENV SPARK_VERSION            2.0.0
ENV HADOOP_PROFILE           2.6
ENV HADOOP_VERSION           2.7.1

### SSH ###

RUN rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_ed25519_key

### USERS ###

RUN echo 'root:datalayer' | chpasswd

RUN groupadd datalayer
RUN useradd -d /home/dataayer -m -s /bin/bash -g datalayer datalayer
RUN echo 'datalayer:datalayer' | chpasswd

### JAVA ###

RUN curl -sL --retry 3 --insecure \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "http://download.oracle.com/otn-pub/java/jdk/8u31-b13/server-jre-8u31-linux-x64.tar.gz" \
  | gunzip \
  | tar x -C /opt/
ENV JAVA_HOME /opt/jdk1.8.0_31
RUN ln -s $JAVA_HOME /opt/java
ENV PATH $JAVA_HOME/bin:$PATH

### PYTHON ###

RUN yum install -y python python-setuptools python-dev numpy python-pip python-matplotlib python-pandas python-pandasql ipython python-nose python-sympy
# RUN yum install -y scipy
RUN easy_install py4j pattern

### MAVEN ###

ENV MAVEN_VERSION 3.3.1
ENV MAVEN_HOME /opt/apache-maven-$MAVEN_VERSION
ENV PATH $PATH:$MAVEN_HOME/bin
RUN curl -sL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
  | gunzip \
  | tar x -C /opt/
RUN ln -s $MAVEN_HOME /opt/maven

### SCALA ###

WORKDIR /opt
RUN curl http://www.scala-lang.org/files/archive/scala-2.11.8.tgz -o scala-2.11.8.tgz
RUN tar xvfz scala-2.11.8.tgz
RUN rm scala-2.11.8.tgz

ENV SCALA_HOME /opt/scala-2.11.8
ENV PATH $SCALA_HOME/bin:$PATH

### R ###

RUN yum install -y R R-devel libcurl-devel openssl-devel

COPY resources/install-R-packages.R /opt/install-R-packages.R
RUN R CMD BATCH /opt/install-R-packages.R /opt/install-R-packages.R.out

### SPARK ###

WORKDIR /opt

RUN curl -sL --retry 3 \
  "http://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_PROFILE.tgz" \
  | gunzip \
  | tar x -C /opt/
#  && ln -s /opt/spark-$SPARK_VERSION-bin-hadoop$HADOOP_PROFILE /opt/spark
#  && rm -rf /opt/spark/examples \
#  && rm /opt/spark/lib/spark-examples*.jar

RUN mv /opt/spark-$SPARK_VERSION-bin-hadoop$HADOOP_PROFILE /opt/spark

ENV SPARK_HOME /opt/spark

# RUN curl http://apache.belnet.be/spark/spark-1.5.2/spark-1.5.2-bin-hadoop2.6.tgz -o spark-1.5.2-bin-hadoop2.6.tgz
# RUN tar xvfz spark-1.5.2-bin-hadoop2.6.tgz

### ZEPPELIN ###

ENV PATH $ZEPPELIN_HOME/zeppelin-web/node:$PATH
ENV PATH $ZEPPELIN_HOME/zeppelin-web/node_modules/grunt-cli/bin:$PATH

RUN git config --global url."https://".insteadOf git://

RUN git clone $ZEPPELIN_REPO_URL $ZEPPELIN_HOME

WORKDIR $ZEPPELIN_HOME

RUN git checkout $ZEPPELIN_REPO_BRANCH

RUN mvn \
  install \
  -Pscala-2.11 \
  -Dscala.binary.version=$SCALA_BINARY_VERSION \
  -Dscala.version=$SCALA_VERSION \
  -Pspark-$SPARK_PROFILE \
  -Dspark.version=$SPARK_VERSION \
  -Psparkr \
  -Ppyspark \
  -Pscala-$SCALA_BINARY_VERSION \
  -Dscala.version=$SCALA_VERSION \
  -Dscala.binary.version=$SCALA_BINARY_VERSION \
  -Phadoop-$HADOOP_PROFILE \
  -Dhadoop.version=$HADOOP_VERSION \
  -Dmaven.findbugs.enable=false \
  -Drat.skip=true \
  -Dcheckstyle.skip=true \
  -pl '!alluxio,!cassandra,!elasticsearch,!file,!flink,!hbase,!ignite,!jdbc,!kylin,!lens,!postgresql' \
  -DskipTests

# Temporary fix to deal with conflicting akka provided jackson jars.
# RUN rm zeppelin-server/target/lib/jackson-*
# RUN rm zeppelin-zengine/target/lib/jackson-*

COPY ./resources/datalayer-cli-colors.sh $ZEPPELIN_HOME/bin/datalayer-cli-colors.sh
COPY ./resources/datalayer-echo-header.sh $ZEPPELIN_HOME/bin/datalayer-echo-header.sh
COPY ./resources/datalayer-zeppelin-start.sh $ZEPPELIN_HOME/bin/datalayer-zeppelin-start.sh
COPY ./resources/log4j.properties $ZEPPELIN_HOME/conf/log4j.properties
COPY ./resources/zeppelin-site.xml $ZEPPELIN_HOME/conf/zeppelin-site.xml
COPY ./resources/zeppelin-env.sh $ZEPPELIN_HOME/conf/zeppelin-env.sh

ENV PATH $ZEPPELIN_HOME/bin:$PATH

RUN mkdir $ZEPPELIN_HOME/logs
RUN mkdir $ZEPPELIN_HOME/run

### WEBAPP ###

COPY ./webapp $ZEPPELIN_HOME/zeppelin-web/dist/

### NOTEBOOK ###

RUN mkdir /notebook
ADD notebook/tutorial /notebook/tutorial
ADD notebook/r-tutorial /notebook/r-tutorial

### DATASET ###

# RUN mkdir /dataset
# ADD dataset /dataset

### HADOOP ###

# RUN mkdir -p /etc/hadoop/conf
# ADD resources/hadoop /etc/hadoop/conf

### CLEAN ###

RUN rm -rf /root/.m2
RUN rm -rf /root/.npm
RUN yum clean all

### INTERFACE ###

EXPOSE 22
EXPOSE 4040
EXPOSE 8080
EXPOSE 8666

### ENTRY POINT ###

ENTRYPOINT ["/opt/zeppelin/bin/datalayer-zeppelin-start.sh"]
