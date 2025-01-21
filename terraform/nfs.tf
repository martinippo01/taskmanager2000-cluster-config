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
        Name = "${var.vpc_name}-nfs"
    }
}

// https://stackoverflow.com/questions/69488032/terraform-how-to-mount-efs-access-point-to-ec2
resource "null_resource" "nfs_provisioner" {
    depends_on = [ aws_instance.nfs ]

    connection {
        host = aws_instance.nfs.public_ip
        type = "ssh"
        user = local.ec2_user
        private_key = file(var.ec2_key_file)
    }

    provisioner "remote-exec" {
      inline = [ 
        "sudo apt-get update -y",
        "sudo apt-get install nfs-common -y",
        "sudo mkdir -p ${var.ec2_nfs_mount_point}",
        "sudo mount -t nfs4 ${aws_instance.nfs.private_ip}:${var.ec2_nfs_mount_point} ${var.ec2_nfs_mount_point}",
        "sudo chown -R ubuntu:ubuntu ${var.ec2_nfs_mount_point}",
        "echo '${aws_instance.nfs.private_ip}:${var.ec2_nfs_mount_point} ${var.ec2_nfs_mount_point} nfs defaults 0 0' | sudo tee -a /etc/fstab"
       ]
    }
}





