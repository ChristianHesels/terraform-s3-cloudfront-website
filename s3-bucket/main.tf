resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  force_destroy = true
  tags = {
    "Name" = var.bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# WWW bucket for redirection
resource "aws_s3_bucket" "www_s3_bucket" {
  bucket = "www.${var.bucket_name}"
  force_destroy = true
  tags = {
    "Name" = "www.${var.bucket_name}"
  }
}

resource "aws_s3_bucket_website_configuration" "www_s3_website_config" {
  bucket = aws_s3_bucket.www_s3_bucket.bucket

  redirect_all_requests_to {
    host_name = var.bucket_name
  }
}
