locals {
  scripts_path = "${path.module}/scripts"
  ec2_ami = "ami-080e1f13689e07408" # Ubuntu 22.04 LTS (HVM), SDD Volume Type
  ec2_user = "ubuntu"
}