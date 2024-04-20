terraform {
  backend "s3" {
    bucket = "your-s3-bucket-name"
    key    = "terraform/state"
    region = "eu-central-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Terraform   = "true"
      Environment = var.env 
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

module "s3-bucket" {
  source      = "./s3-bucket"
  bucket_name = var.domain_name
  source_file = "index.html"
}

module "acm-cert" {
  source      = "./acm-cert"
  domain_name = var.domain_name
  providers = {
    aws = aws.us-east-1
  }
}

module "route53" {
  source      = "./route53"
  domain_name = var.domain_name

  domain_validation_options   = module.acm-cert.domain_validation_options
  www_bucket_website_endpoint = module.s3-bucket.www_bucket_website_endpoint
  acm_certificate_arn         = module.acm-cert.acm_certificate_arn

  providers = {
    aws = aws.us-east-1
  }

  depends_on = [
    module.acm-cert,
  ]
}

module "cloud-front" {
  source              = "./cloud-front"
  acm_certificate_arn = module.acm-cert.acm_certificate_arn
  s3_name             = var.domain_name
  depends_on = [
    module.s3-bucket,
    module.acm-cert,
    module.route53,
  ]
}

module "create-alias" {
  source      = "./create-alias"
  domain_name = var.domain_name

  cloudfront_domain_name    = module.cloud-front.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloud-front.cloudfront_hosted_zone_id
  cloudfront_arn            = module.cloud-front.cloudfront_arn
  zone_id                   = module.route53.zone_id

  depends_on = [
    module.cloud-front,
    module.acm-cert,
    module.route53,
  ]
}