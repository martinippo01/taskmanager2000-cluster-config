# resource "aws_s3_bucket" "pipeline_cache" {
#     bucket = var.s3_pipeline_cache_bucket_name
#     force_destroy = true

#     object_lock_enabled = false

#     tags = {
#         Name = var.s3_pipeline_cache_bucket_name
#     }
# }

# resource "aws_s3_bucket_ownership_controls" "pipeline_cache_ownership_controls" {
#     bucket = aws_s3_bucket.pipeline_cache.id

#     rule {
#         object_ownership = "BucketOwnerPreferred"
#     }
# }

# resource "aws_s3_bucket_server_side_encryption_configuration" "pipeline_cache_encryption" {
#     bucket = aws_s3_bucket.pipeline_cache.id

#     rule {
#         apply_server_side_encryption_by_default {
#             sse_algorithm = "AES256"
#         }
#         bucket_key_enabled = true
#     }
# }

# resource "aws_s3_bucket_public_access_block" "pipeline_cache_public_access_block" {
#     bucket = aws_s3_bucket.pipeline_cache.id

#     block_public_acls       = false
#     block_public_policy     = false
#     ignore_public_acls      = false
#     restrict_public_buckets = false
# }

# resource "aws_s3_bucket_policy" "pipeline_cache_policy" {
#     bucket = aws_s3_bucket.pipeline_cache.id

#     policy = jsonencode({
#         Version = "2012-10-17"
#         Statement = [
#             {
#                 Effect = "Allow"
#                 Principal = {
#                     AWS = data.aws_iam_role.labrole.arn
#                 }
#                 Action = [
#                     "s3:GetObject",
#                     "s3:PutObject"
#                 ]
#                 Resource = [
#                     "${aws_s3_bucket.pipeline_cache.arn}/*"
#                 ]
#             }
#         ]
#     })
# }

