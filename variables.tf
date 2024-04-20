# -- variables.tf -- 

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "vpc_cidr_a" {
  default = "10.1.0.0/16"
}


variable "vpc_cidr_b" {
  default = "10.2.0.0/16"
}

variable "domain_name" {
  default = "your.domain.de"
}