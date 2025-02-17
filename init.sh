#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <file with cluster ip> <file with workers ips>"
  exit 1
fi
if [ ! -f ./id_ed25519 ]; then
    echo "Error: SSH key file ./id_ed25519 not found!"
    exit 1
fi

if [ $(wc -l < "$1") -ne 1 ]; then
    echo "Error: The file $1 must contain exactly one line."
    exit 1
fi

if [ $(wc -l < "$2") -lt 1 ]; then
    echo "Error: The file $2 must contain one or more lines."
    exit 1
fi

join_command="sudo $(ssh -i ./id_ed25519 ubuntu@$(cat $1) -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o IdentitiesOnly=yes -o User=ubuntu "sudo kubeadm token create --print-join-command")"

while IFS= read -r worker_ip; do
    ssh -i ./id_ed25519 ubuntu@$worker_ip -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o IdentitiesOnly=yes -o User=ubuntu "$join_command"
done < "$2"

ssh -i ./id_ed25519 ubuntu@$(cat $1) -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o IdentitiesOnly=yes -o User=ubuntu "kubectl get nodes"