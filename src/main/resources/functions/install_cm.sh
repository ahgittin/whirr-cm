#
# Licensed to Cloudera, Inc. under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# Cloudera, Inc. licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -x
function install_cm() {
  # install 'expect' somewhat aggressively
  if [ -z `which expect` ] ; then
    if [ ! -z `which yum` ] ; then 
      yum install -y expect 
    elif [ ! -z `which apt-get` ] ; then
      # apt race?
      echo first apt-get update at `date`
      apt-get update
      echo second apt-get update at `date`
      apt-get update
      apt-get install -y expect
    else
      echo WARNING - Missing expect software and not sure how to install here. Installation will likely fail.
    fi
  fi

  wget http://archive.cloudera.com/cm4/installer/latest/cloudera-manager-installer.bin
  chmod u+x cloudera-manager-installer.bin
  
  # Use expect for the install to make it appear interactive
  cat >> install <<END
#!/usr/bin/expect -f
set timeout 600
spawn ./cloudera-manager-installer.bin --ui=stdio --noprompt --noreadme --nooptions --i-agree-to-all-licenses
expect EOF
END

  chmod +x install
  ./install
}
