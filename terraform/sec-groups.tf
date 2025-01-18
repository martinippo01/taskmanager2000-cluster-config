resource "aws_security_group" "sg_ec2_egress" {
    depends_on = [ aws_vpc.vpc ]

    name = "${var.vpc_name}-sg-ec2-egress"
    description = "Allow all outbound traffic from EC2 instances"
    vpc_id = aws_vpc.vpc.id

    tags = {
      Name = "${var.vpc_name}-sg-ec2-egress"
    }
}

resource "aws_vpc_security_group_egress_rule" "sg2_ec2_egress_all" {
    depends_on = [ aws_security_group.sg_ec2_egress ]

    security_group_id = aws_security_group.sg_ec2_egress.id
    description = "Allow all outbound traffic"
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_security_group" "sg_ec2_ingress" {
    depends_on = [ aws_vpc.vpc ]

    name = "${var.vpc_name}-sg-ec2-ingress"
    description = "Allow all inbound traffic to EC2 instances"
    vpc_id = aws_vpc.vpc.id

    tags = {
      Name = "${var.vpc_name}-sg-ec2-ingress"
    }
}

resource "aws_vpc_security_group_ingress_rule" "sg2_ec2_ingress_all" {
    depends_on = [ aws_security_group.sg_ec2_ingress ]

    security_group_id = aws_security_group.sg_ec2_ingress.id
    description = "Allow all inbound traffic"
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}
