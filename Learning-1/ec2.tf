# Key pair (login)

resource aws_key_pair my_key {
  key_name = "terra-key"
  public_key = file("terra-key.pub")

}



# VPC & Security Group

resource aws_default_vpc default {
}

resource aws_security_group my_security_group {
  name = "automate-sg"
  description = "this will add a TF generated Security Group"
  vpc_id = aws_default_vpc.default.id   # Interpolation
  


# Inbound rules

ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH is open"
}

ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Http is open"
}


ingress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask app"
}



# Outbound rules

egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All access open for outbound traffic"
}


  tags = {
    Name = "Automate-SG"
  }
}



# EC2 Instance

resource "aws_instance" "my_instance" {
  #count = 2                                                                        # Meta argument
  /* for_each = tomap({                                                             # For_each [Meta argument]
    MKR-automate-micro = "t3.micro",
    MKR-automate-small = "t3.small"
  }) */

  #depends_on = [ aws_security_group.my_security_group, aws_key_pair.my_key ]        # Meta argument

  key_name = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  instance_type = var.ec2_instance_type                                             # Reference from variables.tf file
  #instance_type = each.value                                                       # Part of For_each [Meta argument]
  ami = var.ec2_ami_id                                                              # Debian
  user_data = file("install_nginx.sh")

  /* root_block_device {
  volume_size = var.ec2_root_storage_size
  volume_type = "gp3"
 } */

root_block_device {
  volume_size = var.env == "Prod" ? 20 : var.ec2_root_default_storage_size         # Conditional expression variable
  volume_type = "gp3"
 }


  tags = {
  Name = "MKR-automate"                                                           # Part of For_each [Meta argument]
  #Name = each.key
  }

} 