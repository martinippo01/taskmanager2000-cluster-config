resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"

    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = var.vpc_name
    }  
}

resource "aws_internet_gateway" "igw" {
    depends_on = [aws_vpc.vpc]
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.vpc_name}-igw"
    }
}

resource "aws_route_table" "rt-public" {
    depends_on = [ aws_vpc.vpc, aws_internet_gateway.igw ]
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    route {
        cidr_block = aws_vpc.vpc.cidr_block
        gateway_id = "local"
    }

    tags = {
        Name = "${var.vpc_name}-rt-public"
    }
}

resource "aws_subnet" "subnet-public" {
    depends_on = [ aws_vpc.vpc ]

    vpc_id = aws_vpc.vpc.id
    cidr_block = var.vpc_subnet_public_cidr
    availability_zone = "${var.aws_region}a"

    tags = {
        Name = "${var.vpc_name}-subnet-public"
    }
}

resource "aws_route_table_association" "rta-public" {
    depends_on = [ aws_route_table.rt-public, aws_subnet.subnet-public ]
    subnet_id = aws_subnet.subnet-public.id
    route_table_id = aws_route_table.rt-public.id
}