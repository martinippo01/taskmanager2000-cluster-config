resource "aws_instance" "ec2_k8s_master" {
    depends_on = [ aws_key_pair.ec2_key, aws_security_group.sg_ec2_egress, aws_security_group.sg_ec2_ingress, aws_subnet.subnet-public, aws_security_group.sg_ssh_my_ip ]

    ami = local.ec2_ami
    instance_type = var.ec2_k8s_instance_type
    key_name = aws_key_pair.ec2_key.key_name
    vpc_security_group_ids = [
        aws_security_group.sg_ec2_egress.id,
        aws_security_group.sg_ec2_ingress.id,
        aws_security_group.sg_ssh_my_ip.id
    ]

    subnet_id = aws_subnet.subnet-public.id
    associate_public_ip_address = true

    iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

    tags = {
        Name = "${var.vpc_name}-ec2-k8s-master"
    }  

    user_data_base64 = base64encode(
        templatefile("${local.scripts_path}/k8s-master-userdata.sh", {})
    )
}

resource "aws_instance" "ec2_k8s_workers" {
    depends_on = [ aws_key_pair.ec2_key, aws_security_group.sg_ec2_egress, aws_security_group.sg_ec2_ingress, aws_subnet.subnet-public, aws_security_group.sg_ssh_my_ip ]

    count = var.ec2_k8s_workers_count
    ami = local.ec2_ami
    instance_type = var.ec2_k8s_instance_type
    key_name = aws_key_pair.ec2_key.key_name
    vpc_security_group_ids = [
        aws_security_group.sg_ec2_egress.id,
        aws_security_group.sg_ec2_ingress.id,
        aws_security_group.sg_ssh_my_ip.id
    ]

    subnet_id = aws_subnet.subnet-public.id
    associate_public_ip_address = true

    iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

    tags = {
        Name = "${var.vpc_name}-ec2-k8s-worker-${count.index + 1}"
    }

    user_data_base64 = base64encode(
        templatefile("${local.scripts_path}/k8s-worker-userdata.sh", {
            worker_id = count.index + 1
        })
    )
}