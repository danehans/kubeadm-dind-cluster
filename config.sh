# DIND subnet (/16 is always used for IPv4 and /64 for IPv6)
#DIND_SUBNET=10.192.0.0
DIND_SUBNET=2001:db8::

# Apiserver port
APISERVER_PORT=${APISERVER_PORT:-8080}

# Number of nodes. 0 nodes means just one master node.
# In case of NUM_NODES=0 'node-role.kubernetes.io/master' taint is removed
# from the master node.
NUM_NODES=${NUM_NODES:-2}

# Use non-dockerized build
# KUBEADM_DIND_LOCAL=

# Use prebuilt DIND image
DIND_IMAGE="${DIND_IMAGE:-mirantis/kubeadm-dind-cluster:v1.6}"

# Set to non-empty string to enable building kubeadm
# BUILD_KUBEADM=y

# Set to non-empty string to enable building hyperkube
# BUILD_HYPERKUBE=y

# download kubectl on the host
# Set automatically based on DIND image version tag
# if image version tag is of the form vNNN.NNN
# LOCAL_KUBECTL_VERSION="${LOCAL_KUBECTL_VERSION:-v1.7}"

# Set custom URL for Dashboard yaml file
# DASHBOARD_URL="${DASHBOARD_URL:-https://rawgit.com/kubernetes/dashboard/bfab10151f012d1acc5dfb1979f3172e2400aa3c/src/deploy/kubernetes-dashboard.yaml}"

# CNI plugin to use (bridge, flannel, calico, calico-kdd, weave). Defaults to 'bridge'
# In case of 'bridge' plugin, additional hacks are employed to bridge
# DIND containers together.
CNI_PLUGIN="${CNI_PLUGIN:-bridge}"

# When using Calico with Kubernetes as the datastore (calico-kdd) your
# controller manager needs to be started with `--cluster-cidr=192.168.0.0/16`.
# More information here: http://docs.projectcalico.org/v2.3/getting-started/kubernetes/installation/hosted/kubernetes-datastore/
# POD_NETWORK_CIDR="192.168.0.0/16"

# Set SKIP_SNAPSHOT to non-empty string to skip making the snapshot.
# This may be useful for CI environment where the cluster is never
# restarted after it's created.
# SKIP_SNAPSHOT=y

# The Internet Protocol (IP) version to use for DIND networking.
# Supports ipv4 (default) and ipv6.
PROTOCOL="${PROTOCOL:-ipv6}"

# Used for specifying the IPv6 CIDR for DIND networking when PROTOCOL=ipv6.
# Defaults to 2001:db8::/64.
# DIND_IPV6_CIDR="${DIND_IPV6_CIDR:-2001:db8::/64}"