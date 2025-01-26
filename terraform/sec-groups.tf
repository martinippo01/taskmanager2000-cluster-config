resource "aws_security_group" "sg_ec2_egress" {
    depends_on = [ aws_vpc.vpc ]

    name = "${var.vpc_name}-sg-ec2-egress"
    description = "Allow all outbound traffic from EC2 instances"
    vpc_id = aws_vpc.vpc.id

    tags = {
      Name = "${var.vpc_name}-sg-ec2-egress"
    }
}

resource "aws_vpc_security_group_egress_rule" "sg_ec2_egress_all" {
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

resource "aws_vpc_security_group_ingress_rule" "sg_ec2_ingress_all" {
    depends_on = [ aws_security_group.sg_ec2_ingress ]

    security_group_id = aws_security_group.sg_ec2_ingress.id
    description = "Allow all inbound traffic"
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_security_group" "sg_ec2_ingress_nfs" {
    depends_on = [ aws_vpc.vpc ]

    name = "${var.vpc_name}-sg-ec2-ingress-nfs"
    description = "Allow NFS traffic to NFS server"
    vpc_id = aws_vpc.vpc.id

    tags = {
      Name = "${var.vpc_name}-sg-ec2-ingress-nfs"
    }  
}

resource "aws_vpc_security_group_ingress_rule" "sg_ec2_ingress_nfs" {
    depends_on = [ aws_security_group.sg_ec2_ingress_nfs, aws_vpc.vpc ]

    security_group_id = aws_security_group.sg_ec2_ingress_nfs.id
    description = "Allow NFS traffic (TCP)"
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    ip_protocol = "tcp"
    from_port = 2049
    to_port = 2049
}

resource "aws_vpc_security_group_ingress_rule" "sg_ec2_ingress_nfs_udp" {
    depends_on = [ aws_security_group.sg_ec2_ingress_nfs, aws_vpc.vpc ]

    security_group_id = aws_security_group.sg_ec2_ingress_nfs.id
    description = "Allow NFS traffic (UDP)"
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    ip_protocol = "udp"
    from_port = 2049
    to_port = 2049
}

resource "aws_vpc_security_group_ingress_rule" "sg_ec2_ingress_nfs_mount" {
    depends_on = [ aws_security_group.sg_ec2_ingress_nfs, aws_vpc.vpc ]

    security_group_id = aws_security_group.sg_ec2_ingress_nfs.id
    description = "Allow NFS mount traffic (TCP)"
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    ip_protocol = "tcp"
    from_port = 111
    to_port = 111
}

resource "aws_vpc_security_group_ingress_rule" "sg_ec2_ingress_nfs_mount_udp" {
    depends_on = [ aws_security_group.sg_ec2_ingress_nfs, aws_vpc.vpc ]

    security_group_id = aws_security_group.sg_ec2_ingress_nfs.id
    description = "Allow NFS mount traffic (UDP)"
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    ip_protocol = "udp"
    from_port = 111
    to_port = 111
}

resource "aws_security_group" "sg_vpc_endpoint" {
    depends_on = [ aws_vpc.vpc ]

    name = "${var.vpc_name}-sg-vpc-endpoint"
    description = "Allow all internal traffic to VPC endpoint"
    vpc_id = aws_vpc.vpc.id

    tags = {
      Name = "${var.vpc_name}-sg-vpc-endpoint"
    }
}

resource "aws_vpc_security_group_ingress_rule" "sg_vpc_endpoint_ingress" {
    depends_on = [ aws_security_group.sg_vpc_endpoint, aws_vpc.vpc ]

    security_group_id = aws_security_group.sg_vpc_endpoint.id
    description = "Allow all internal traffic to VPC endpoint"
    cidr_ipv4 = aws_vpc.vpc.cidr_block
    ip_protocol = "-1"  
}

resource "aws_security_group" "sg_ssh_my_ip" {
    depends_on = [ aws_vpc.vpc ]

    name = "${var.vpc_name}-sg-ssh-my-ip"
    description = "Allow SSH traffic from my IP"
    vpc_id = aws_vpc.vpc.id

    tags = {
      Name = "${var.vpc_name}-sg-ssh-my-ip"
    }
} 

resource "aws_vpc_security_group_ingress_rule" "sg_ssh_my_ip_ingress" {
    depends_on = [ aws_security_group.sg_ssh_my_ip, aws_vpc.vpc ]

    security_group_id = aws_security_group.sg_ssh_my_ip.id
    description = "Allow SSH traffic from my IP"
    cidr_ipv4 = "${split("\n", data.http.my_ip.response_body)[0]}/32"
    ip_protocol = "tcp"
    from_port = 22
    to_port = 22
}

