variable "aws_region" {
  type    = string
  default = "us-east-1"
}


variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}


variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}


variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.2.0/24", "10.0.3.0/24"]
}


variable "instance_type" {
  type    = string
  default = "t2.micro"
}


variable "key_name" {
  type    = string
  default = "" # optional
}


variable "asg_min_size" { default = 1 }
variable "asg_max_size" { default = 2 }
variable "asg_desired" { default = 1 }