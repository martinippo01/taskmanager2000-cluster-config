locals {
  scripts_path = "${path.module}/scripts"
  ec2_ami = "ami-080e1f13689e07408" # Ubuntu 22.04 LTS (HVM), SDD Volume Type
  ec2_user = "ubuntu"
  k8s_crio_os = "xUbuntu_22.04"
  k8s_crio_version = "1.28"
  k8s_version = "1.29.0-1.1"
  k8s_network_cidr = "192.168.0.0/16"
}