# -- variables.tf -- 

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "domain_name" {
  default = "your.domain.de"
}

variable "project_name" {
  description = "The project name used for resource naming and tagging."
  default     = "project name"
}

variable "env" {
  description = "Project environment"
  default = "dev"
}