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
  default = "my-project.de"
}

variable "project_name" {
  description = "The project name used for resource naming and tagging."
  default     = "my-project"
}

variable "env" {
  description = "Project environment"
  default     = "prod"
}

variable "github_repo" {
  description = "Github Repo"
  default = "repo:UserName/project:ref:refs/heads/*"
}

variable "bucket_name_global_infra" {
  description = "Name of the S3 Bucket containing global infra configurations"
  default = "terraform-state-bucket-infra-global"
}