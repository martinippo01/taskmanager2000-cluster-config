#!/bin/bash

# Update and upgrade the system
sudo apt-get update -y && sudo apt-get upgrade -y

# Install the NFS client
sudo apt-get install nfs-common -y

# Start the NFS client service
sudo service nfs-server start

# Create a directory to mount the NFS share
sudo mkdir -p ${nfs_mount_point}

# Mount the NFS share
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${nfs_server_ip}:${nfs_mount_point} ${nfs_mount_point}

# Change the ownership of the mounted directory
sudo chown -R ubuntu:ubuntu ${nfs_mount_point}

# Add the NFS share to the /etc/fstab file
echo "${nfs_server_ip}:${nfs_mount_point} ${nfs_mount_point} nfs defaults 0 0" | sudo tee -a /etc/fstab

# Install the NFS server
