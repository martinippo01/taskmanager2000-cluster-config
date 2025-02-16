#!/bin/bash

# Update and upgrade the system
sudo apt-get update -y && sudo apt-get upgrade -y

# Install the NFS client
sudo apt-get install -y nfs-kernel-server

# Create a directory to mount the NFS share
sudo mkdir -p ${nfs_mount_point}

# Allow the NFS client to access the NFS server
sudo chown -R nobody:nogroup ${nfs_mount_point}
sudo chmod 777 ${nfs_mount_point}

# Allow the NFS client to access the NFS server
echo "${nfs_mount_point} ${nfs_client_ip_range}(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports

# Export the NFS share
sudo exportfs -a

# Restart the NFS server
sudo systemctl restart nfs-kernel-server

# Allow the NFS client to access the NFS server through the firewall
sudo ufw allow from ${nfs_client_ip_range} to any port nfs

# Enable the NFS server to start on boot
sudo systemctl enable nfs-kernel-server

################### Disable Firewall ###################
sudo ufw disable

sudo reboot
