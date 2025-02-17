variable "aws_region" {
    description = "AWS region"
    type = string
    default     = "us-east-1"
}

variable "vpc_name" {
    description = "Name of the VPC"
    type = string
    default     = "my-vpc"
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type = string
    default     = "10.0.0.0/16"
}

variable "vpc_subnet_public_cidr" {
    description = "CIDR block for the public subnet"
    type = string
    default     = "10.0.0.0/24"
}

variable "ec2_key_file" {
    description = "Path to the EC2 key file"
    type = string
    default     = "~/.ssh/id_ed25519.pub"
}

variable "ec2_k8s_instance_type" {
    description = "Instance type for the EC2 instance"
    type = string
    default     = "t2.medium"
}

variable "ec2_k8s_workers_count" {
    description = "Number of worker nodes in the Kubernetes cluster"
    type = number
    default     = 3  
}

# variable "ec2_pipeline_instance_type" {
#     description = "Instance type for the EC2 instance"
#     type = string
#     default     = "t2.micro"  
# }

variable "ec2_nfs_instance_type" {
    description = "Instance type for the EC2 instance"
    type = string
    default     = "t2.micro"  
}

variable "ec2_nfs_volume_size" {
    description = "Size of the EBS volume for the NFS server"
    type = number
    default     = 8
}

variable "ec2_nfs_server_mount_point" {
    description = "Mount point for the NFS server"
    type = string
    default     = "/mnt/nfs"
}

variable "ec2_nfs_client_mount_point" {
    description = "Mount point for the NFS client"
    type = string
    default     = "/mnt/nfs"
}

# variable "pipeline_auth_token" {
#     description = "Authentication token for the GitLab pipeline runner"
#     type = string  
# }

# variable "s3_pipeline_cache_bucket_name" {
#     description = "Name of the S3 bucket for the pipeline cache"
#     type = string
#     default     = "my-pipeline-cache"
  
# }

# variable "aws_access_key_id" {
#   description = "AWS access key ID"
#   type = string
# }

# variable "aws_secret_access_key" {
#   description = "AWS secret access key"
#   type = string
# }

# variable "aws_session_token" {
#   description = "AWS session token"
#   type = string
# }