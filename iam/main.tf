
data "terraform_remote_state" "global_infra" {
  backend = "s3"

  config = {
    bucket = var.bucket_name_global_infra 
    key    = "terraform/state"
    region = "eu-central-1"
  }
}

resource "aws_iam_role" "github_iam_role" {
  name = "${var.iam_role_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = [data.terraform_remote_state.global_infra.outputs.github_identity_provider_arn] 
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = var.github_repo 
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy" {
  name = "${var.policy_name}"
  description = "Policy for accessing S3 and CloudFront"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "VisualEditor0"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation"
        ]
        Resource = [
          var.cloudfront_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.github_iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}