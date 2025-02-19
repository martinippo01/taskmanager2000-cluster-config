#!/bin/bash

# Validate that the correct number of arguments is passed
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <file with master ip> <file with worker ips>"
  exit 1
fi

# Validate if SSH key exists
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "Error: SSH key file ~/.ssh/id_ed25519 not found!"
    exit 1
fi

# Read the master IP and worker IPs
MASTER_IP=$(<"$1")
WORKER_IPS=$(<"$2")

# Check if the master node is ready
echo "==============Checking if the master node is ready==============="
echo "---$MASTER_IP---"
ssh -i ~/.ssh/id_ed25519 ubuntu@$MASTER_IP -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o IdentitiesOnly=yes -o User=ubuntu "kubectl get nodes"

# Get the join command from the master node
echo "========================Getting join command======================"
join_command="sudo $(ssh -i ~/.ssh/id_ed25519 ubuntu@$MASTER_IP -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o IdentitiesOnly=yes -o User=ubuntu 'sudo kubeadm token create --print-join-command')"

# Split the worker IPs and iterate over them
echo "==============Running the join command on each worker=============="
for worker_ip in $WORKER_IPS; do
    echo "---$worker_ip---"
    ssh -i ~/.ssh/id_ed25519 ubuntu@$worker_ip -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o IdentitiesOnly=yes -o User=ubuntu "$join_command"
done

# Verify the nodes again after joining
echo "==============Checking nodes after joining workers==============="
ssh -i ~/.ssh/id_ed25519 ubuntu@$MASTER_IP -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o IdentitiesOnly=yes -o User=ubuntu "kubectl get nodes"
