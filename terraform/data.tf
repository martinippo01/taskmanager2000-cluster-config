data "aws_iam_role" "labrole" {
  name = "LabRole"
}

data "http" "my_ip" {
  url = "http://checkip.amazonaws.com"
}