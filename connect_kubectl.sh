#!/bin/bash

GROUP_ID=91711741
TOKEN=glpat-XxEE1Z54H_JDsUXW1RbE

echo "=============Retrieving Cluster IP from Gitlab=============="
MASTER_IP=$(curl --silent --header "PRIVATE-TOKEN: $TOKEN" "https://gitlab.com/api/v4/groups/$GROUP_ID/variables/CLUSTER_IP" | jq -r '.value')
if [ -z "$MASTER_IP" ]; then
  echo "Error: Failed to retrieve MASTER_IP"
  exit 1
fi

echo $MASTER_IP

# Validate if SSH key exists and no argument is passed
if [ ! -f ~/.ssh/id_ed25519 ] && [ -z "$1" ]; then
  echo "Error: SSH key file ~/.ssh/id_ed25519 not found and no argument provided!"
  exit 1
fi

# Determine the SSH key path
SSH_KEY_PATH="${1:-~/.ssh/id_ed25519}"

echo "==============Get the kube config from master==============="
scp -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o IdentitiesOnly=yes -o User=ubuntu ubuntu@$MASTER_IP:~/.kube/config ~/.kube/config
echo "===============Modifying the kubeconfig file================"
sed -i '4d' ~/.kube/config
sed -i "s/server: https:\/\/.*:6443/server: https:\/\/$MASTER_IP:6443\n    insecure-skip-tls-verify: true/g" ~/.kube/config
echo "=============Validate that kubectl is connected============="
kubectl get nodes
if kubectl get nodes > /dev/null 2>&1; then
echo "====================Kubectl is ready========================"
else
    echo "Error: Kubectl command failed"
    exit 1
fi
 