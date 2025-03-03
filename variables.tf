variable "env" {
 description = "The environment of the AWS infrastructure"
 type        = string
 default     = "dev"
}

variable "vpc_name" {
 description = "The VPC Name to use"
 type        = string
 default     = "arp-tf-ebs-vpc"
}

variable "subnet_name" {
 description = "The subnet Name to use"
 type        = string
 default     = "arp-tf-ebs-vpc-public-us-east-1b"
}
variable "aws_instance" {
 description = "The instance Name to use"
 type        = string
 default = "value"
}