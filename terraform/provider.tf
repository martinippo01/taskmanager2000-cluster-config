provider "aws" {
  region = var.aws_region
  profile = "default"
  shared_credentials_files = ["~/.aws/credentials"]
}