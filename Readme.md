# Terraform Configuration for a S3 Bucket with Cloudfront

## `terraform init`

Add your `domain_name` to the variables.tf file and supply the name of the S3 Bucket that should contain the Terraform state in the Terraform backend in main.tf.

## `terraform apply`

You have to manually add the DNS Records from the created Hosted Zone to your registered Domain DNS entries when reaching the `module.route53.aws_acm_certificate_validation.cert_validation: Still creating...` task.

If working with Subodmains make sure to add the correct DNS Records to the main Hosted Zone (for example add dev.totalthunfisch.de as a NS Record to the totalthunfisch.de Hosted Zone and add the NS Entries that were automatically generated from AWS from your dev.totalthunfisch.de hosted Zone). When using a root domain, make sure to add the DNS Records from your registered Domain to the new Hosted Zone.
The Certificate Validation step can take a few Minutes.

## Connecting AWS with Github Actions

To use Github Actions with AWS a IAM Identity Provider is needed. Add a Provider `token.actions.githubusercontent.com` with the Audience `sts.amazonaws.com`. Afterwards create a new Role containing the S3 Resources, the Github Repo and the Cloudfront Resources which can be invalidated. The Policy could look something like this:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": ["s3:PutObject", "s3:GetObject", "s3:ListBucket"],
      "Resource": ["arn:aws:s3:::yourdomain.de", "arn:aws:s3:::yourdomain.de/*"]
    },
    {
      "Effect": "Allow",
      "Action": ["cloudfront:CreateInvalidation"],
      "Resource": ["arn:aws:cloudfront::0000000000:distribution/XXXXXXXXXX"]
    }
  ]
}
```
