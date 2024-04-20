resource "aws_route53_record" "root_domain" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

data "aws_iam_policy_document" "allow_access_from_cloudfront" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.domain_name}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [var.cloudfront_arn]
    }
  }
}


resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = var.domain_name
  policy = data.aws_iam_policy_document.allow_access_from_cloudfront.json
}