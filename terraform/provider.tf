# provider "aws" {
#   region = var.aws_region
#   profile = "default"
#   shared_credentials_files = ["~/.aws/credentials"]
# }
provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  token = var.aws_session_token
}