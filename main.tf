locals {
 resource_prefix = "arp-tr"
}

module "vpc" {
 source  = "terraform-aws-modules/vpc/aws"

 name = "arp-tr-ebs-vpc" # Change this!!!
 cidr = "10.0.0.0/16"

 azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
 private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
 public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

 #enable_nat_gateway   = true
 #single_nat_gateway   = true
 #enable_dns_hostnames = true

 tags = {
  Terraform = "true"
 }
}



resource "aws_instance" "public" {
 ami                         = "ami-053a45fff0a704a47" #Challenge, find the AMI ID of Amazon Linux 2 in us-east-1
 instance_type               = "t2.micro"
 subnet_id                   = module.vpc.public_subnets[0]
 associate_public_ip_address = true
 key_name                    = "arpita-keypair" #Change to your keyname, e.g. jazeel-key-pair
 vpc_security_group_ids = [aws_security_group.allow_ssh.id]
 tags = {
   Name = "${ local.resource_prefix }-ec2-${ var.env }" # Ensure your
 }
}


resource "aws_security_group" "allow_ssh" {
 name        = "${ local.resource_prefix }-security-group-ssh"
 description = "Allow SSH inbound"
 vpc_id      = module.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
 security_group_id = aws_security_group.allow_ssh.id
 cidr_ipv4         = "0.0.0.0/0" 
 from_port         = 22
 ip_protocol       = "tcp"
 to_port           = 22
}

output "ec2_public_dns" {
 value = aws_instance.public.public_dns
}

resource "aws_ebs_volume" "my_volume" {
  availability_zone = aws_instance.public.availability_zone
  size             = 1
 type             = "gp3"          # Volume type (gp3, gp2, io1, etc.)
  tags = {
    Name = "MyEBSVolume"
  }

}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.my_volume.id
  instance_id = aws_instance.public.id
}



