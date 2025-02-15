#!/bin/bash

sudo kubeadm token create --print-join-command > ~/join-command.sh

worker_ips=$(cat ~/worker_ips.txt)
for ip in $worker_ips; do
    echo "Connecting to $ip"
    scp -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o IdentitiesOnly=yes -o User=ubuntu join-command.sh ubuntu@$ip:~/join-command.sh
    ssh -i ~/.ssh/id_ed25519 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o IdentitiesOnly=yes -o User=ubuntu ubuntu@$ip "sudo bash ~/join-command.sh"
done