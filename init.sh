#!/bin/bash

GROUP_ID=91711741
TOKEN=glpat-XxEE1Z54H_JDsUXW1RbE

echo "==============Retrieving Cluster IP from Gitlab==============="
MASTER_IP=$(curl --silent --header "PRIVATE-TOKEN: $TOKEN" "https://gitlab.com/api/v4/groups/$GROUP_ID/variables/CLUSTER_IP" | jq -r '.value')
if [ -z "$MASTER_IP" ]; then
  echo "Error: Failed to retrieve MASTER_IP"
  exit 1
fi

echo "==============Retrieving Worker IPs from Gitlab==============="
WORKER_IPS=$(curl --silent --header "PRIVATE-TOKEN: $TOKEN" "https://gitlab.com/api/v4/groups/$GROUP_ID/variables/WORKER_IPS" | jq -r '.value')
if [ -z "$WORKER_IPS" ]; then
  echo "Error: Failed to retrieve WORKER_IPS"
  exit 1
fi

# Validate if SSH key exists and no argument is passed
if [ ! -f ~/.ssh/id_ed25519 ] && [ -z "$1" ]; then
  echo "Error: SSH key file ~/.ssh/id_ed25519 not found and no argument provided!"
  exit 1
fi

# Determine the SSH key path
SSH_KEY_PATH="${1:-~/.ssh/id_ed25519}"

# # Validate that the correct number of arguments is passed
# if [ "$#" -ne 2 ]; then
#   echo "Usage: $0 <file with master ip> <file with worker ips>"
#   exit 1
# fi

# # Validate if SSH key exists
# if [ ! -f ~/.ssh/id_ed25519 ]; then
#     echo "Error: SSH key file ~/.ssh/id_ed25519 not found!"
#     exit 1
# fi

# # Read the master IP and worker IPs
# MASTER_IP=$(<"$1")
# WORKER_IPS=$(<"$2")

# Check if the master node is ready
echo "==============Checking if the master node is ready==============="
echo "---$MASTER_IP---"
ssh -i "$SSH_KEY_PATH" ubuntu@$MASTER_IP -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o IdentitiesOnly=yes -o User=ubuntu "kubectl get nodes"

# Get the join command from the master node
echo "========================Getting join command======================"
join_command="sudo $(ssh -i "$SSH_KEY_PATH" ubuntu@$MASTER_IP -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o IdentitiesOnly=yes -o User=ubuntu 'sudo kubeadm token create --print-join-command')"

# Split the worker IPs and iterate over them
echo "==============Running the join command on each worker=============="
for worker_ip in $WORKER_IPS; do
    echo "---$worker_ip---"
    ssh -i "$SSH_KEY_PATH" ubuntu@$worker_ip -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o IdentitiesOnly=yes -o User=ubuntu "$join_command"
done

# Verify the nodes again after joining
echo "==============Checking nodes after joining workers==============="
ssh -i "$SSH_KEY_PATH" ubuntu@$MASTER_IP -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o IdentitiesOnly=yes -o User=ubuntu "kubectl get nodes"
