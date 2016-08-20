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

export CUR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $CUR_DIR/resources/datalayer-cli-colors.sh

export CONTAINER_NAME=zeppelin-datalayer

echo
echo -e "Stopping "$YELLOW"$CONTAINER_NAME"$NOCOLOR" container..."
docker stop $CONTAINER_NAME
echo

echo -e "Removing "$YELLOW"$CONTAINER_NAME"$NOCOLOR" container..."
docker rm $CONTAINER_NAME
echo
