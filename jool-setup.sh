#!/bin/bash
# Copyright 2017 Mirantis
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail
set -o errtrace

JOOL_VERSION="${JOOL_VERSION:-3.5.4}"
JOOL_INTERFACE="$(route -n | grep UG | awk '{print $8}')"
JOOL_IPV4_ADDRESS="$(ip addr show ${JOOL_INTERFACE} | grep "inet" | awk '$1 == "inet" {print $2}' | cut -d/ -f1)"
JOOL_IPV4_PORT_RANGE="${JOOL_IPV4_PORT_RANGE:-7000-8000}"
JOOL_IPV6_PREFIX="${JOOL_IPV6_PREFIX:-64:ff9b::/96}"

echo "Installing Jool-${JOOL_VERSION} dependencies..."
sudo apt-get update && sudo apt-get install -y zip gcc make linux-headers-$(uname -r) dkms \
gcc make pkg-config libnl-genl-3-dev autoconf

echo "Installing Jool-${JOOL_VERSION} kernel module..."
curl -O https://raw.githubusercontent.com/NICMx/releases/master/Jool/Jool-${JOOL_VERSION}.zip
unzip Jool-${JOOL_VERSION}.zip 
sudo dkms install Jool-${JOOL_VERSION}

echo "Installing Jool-${JOOL_VERSION} userspace application..."
cd Jool-${JOOL_VERSION}/usr && ./autogen.sh && ./configure && sudo make && sudo make install

echo "Configuring Jool..."
sudo bash -c 'cat << EOF > /etc/sysctl.conf
net.ipv6.conf.all.forwarding=1
EOF'

cat >> ~/.bashrc << EOF
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
EOF

echo "alias jool='/usr/local/bin/jool'" >> ~/.bash_aliases
source ~/.bashrc

sudo modprobe jool
sudo jool -4 -a ${JOOL_IPV4_ADDRESS} ${JOOL_IPV4_PORT_RANGE} 
sudo jool -6 -a ${JOOL_IPV6_PREFIX} 

echo "Deployment complete!"
set +x
