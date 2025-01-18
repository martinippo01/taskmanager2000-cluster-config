resource "aws_instance" "pipeline" {
    depends_on = [ aws_key_pair.ec2_key, aws_security_group.sg_ec2_egress, aws_security_group.sg_ec2_ingress, aws_subnet.subnet-public ]

    ami = var.ec2_ami
    instance_type = var.ec2_pipeline_instance_type
    key_name = aws_key_pair.ec2_key.key_name
    vpc_security_group_ids = [
        aws_security_group.sg_ec2_egress.id,
        aws_security_group.sg_ec2_ingress.id
    ]

    subnet_id = aws_subnet.subnet-public.id
    associate_public_ip_address = true

    tags = {
        Name = "${var.vpc_name}-pipeline"
    }  
}