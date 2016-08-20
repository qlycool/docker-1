# There are several ways to configure Zeppelin
#
# 1. Pass individual --environment variables during docker run
#
# 2. Assign a volume and change the conf directory i.e.,
#    -e "ZEPPELIN_CONF_DIR=/zeppelin-conf" --volumes ./conf:/zeppelin-conf
#
# 3. When customizing the Dockerfile, add ENV instructions
#
# 4. Write variables to zeppelin-env.sh during install.sh, as
#    we're doing here.
#
# See conf/zeppelin-env.sh.template for additional
# Zeppelin environment variables to set from here.
#

export ZEPPELIN_MEM="-Xmx1024m"
# export ZEPPELIN_JAVA_OPTS="-Dspark.home=/usr/spark"
