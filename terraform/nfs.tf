resource "aws_instance" "nfs" {
    depends_on = [ aws_key_pair.ec2_key, aws_security_group.sg_ec2_egress, aws_security_group.sg_ec2_ingress_nfs, aws_subnet.subnet-public ]

    ami = local.ec2_ami
    instance_type = var.ec2_nfs_instance_type
    key_name = aws_key_pair.ec2_key.key_name
    vpc_security_group_ids = [
        aws_security_group.sg_ec2_egress.id,
        aws_security_group.sg_ec2_ingress_nfs.id
    ]

    subnet_id = aws_subnet.subnet-public.id
    associate_public_ip_address = true

    root_block_device {
        volume_size = var.ec2_nfs_volume_size
        volume_type = "gp2"
        delete_on_termination = true
    }

    tags = {
        Name = "${var.vpc_name}-ec2-nfs"
    }

    user_data = base64encode(
        templatefile("${local.scripts_path}/nfs-userdata.sh", {
            nfs_mount_point = var.ec2_nfs_mount_point
            nfs_server_ip = self.private_ip
        })
    )
}





