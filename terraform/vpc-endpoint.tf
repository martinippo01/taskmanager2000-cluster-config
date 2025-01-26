# resource "aws_vpc_endpoint" "pipeline_s3_endpoint" {
#     depends_on = [ aws_vpc.vpc, aws_subnet.subnet-public, aws_security_group.sg_vpc_endpoint ]

#     vpc_id = aws_vpc.vpc.id
#     service_name = "com.amazonaws.${var.aws_region}.s3"
#     vpc_endpoint_type = "Interface"
#     subnet_ids = [aws_subnet.subnet-public.id]
#     security_group_ids = [aws_security_group.sg_vpc_endpoint.id]
#     private_dns_enabled = true

#     dns_options {
#       dns_record_ip_type = "ipv4"
#       private_dns_only_for_inbound_resolver_endpoint = true
#     }

#     tags = {
#         Name = "${var.vpc_name}-s3-endpoint"
#     }

#     policy = jsonencode({
#         Version = "2012-10-17",
#         Statement = [
#             {
#                 Effect = "Allow",
#                 Principal = {
#                     AWS = data.aws_iam_role.labrole.arn
#                 }
#                 Action = "*",
#                 Resource = aws_s3_bucket.pipeline_cache.arn
#             }
#         ]
#     })
  
# }