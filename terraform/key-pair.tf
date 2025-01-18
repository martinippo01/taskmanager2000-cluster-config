resource "aws_key_pair" "ec2_key" {
    key_name   = "ec2-key"
    public_key = file(var.ec2_key_file)  
}