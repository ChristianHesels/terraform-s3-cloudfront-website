output "bucket_name" {
  value = aws_s3_bucket.s3_bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
}

output "bucket_id" {
  value = aws_s3_bucket.s3_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

output "www_bucket_website_endpoint" {
  value = aws_s3_bucket_website_configuration.www_s3_website_config.website_endpoint
}