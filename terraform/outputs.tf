# output "ec2_pipeline_public_ip" {
#   value = aws_instance.pipeline.public_ip
#   description = "The public IP address of the pipeline EC2 instance"
# }

output "ec2_k8s_master_public_ip" {
  value = aws_instance.ec2_k8s_master.public_ip
  description = "The public IP address of the Kubernetes master EC2 instance"
}

output "ec2_k8s_workers_public_ips" {
  value = [for instance in aws_instance.ec2_k8s_workers : instance.public_ip]
  description = "The public IP addresses of the Kubernetes worker EC2 instances"
}

output "ec2_nfs_server_public_ip" {
  value = aws_instance.nfs.public_ip
  description = "The public IP address of the NFS server EC2 instance"
}

output "ec2_nfs_server_private_ip" {
  value = aws_instance.nfs.private_ip
  description = "The private IP address of the NFS server EC2 instance"
}

output "ec2_nfs_server_dns_name" {
  value = aws_instance.nfs.public_dns
  description = "The public DNS name of the NFS server EC2 instance"
}

output "ec2_nfs_server_url" {
  value = "nfs://${aws_instance.nfs.public_dns}${var.ec2_nfs_server_mount_point}"
  description = "The NFS URL of the NFS server EC2 instance"
}

