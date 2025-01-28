# resource "aws_instance" "pipeline" {
#     depends_on = [ aws_key_pair.ec2_key, aws_security_group.sg_ec2_egress, aws_security_group.sg_ec2_ingress, aws_subnet.subnet-public, aws_security_group.sg_ssh_my_ip ]

#     ami = local.ec2_ami
#     instance_type = var.ec2_pipeline_instance_type
#     key_name = aws_key_pair.ec2_key.key_name
#     vpc_security_group_ids = [
#         aws_security_group.sg_ec2_egress.id,
#         aws_security_group.sg_ec2_ingress.id,
#         aws_security_group.sg_ssh_my_ip.id
#     ]

#     subnet_id = aws_subnet.subnet-public.id
#     associate_public_ip_address = true

#     # iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

#     tags = {
#         Name = "${var.vpc_name}-ec2-pipeline"
#     }  

#     user_data_base64 = base64encode(
#         templatefile("${local.scripts_path}/pipeline-userdata.sh", {
#             auth_token = var.pipeline_auth_token,
#             gitlab_runner_cache_bucket_name = var.s3_pipeline_cache_bucket_name
#         })
#     )
# }