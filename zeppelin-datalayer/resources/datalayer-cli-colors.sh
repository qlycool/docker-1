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
