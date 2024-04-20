# Terraform Configuration for a S3 Bucket with Cloudfront

## `terraform init`

Add your `domain_name` to the variables.tf file and supply the name of the S3 Bucket that should contain the Terraform state in the Terraform backend in main.tf.

## `terraform apply`

You have to manually add the DNS Records from your registered Domain to the newly created Hosted Zone NS Record when terraform is stuck in the `module.route53.aws_acm_certificate_validation.cert_validation: Still creating...` task.
This will only work if the `domain_name` is part of one of your registered Domains.

If working with Subodmains make sure to add the correct DNS Records to the main Hosted Zone (for example add dev.totalthunfisch.de as a NS Record to the totalthunfisch.de Hosted Zone and add the NS Entries that were automatically generated from AWS from your dev.totalthunfisch.de hosted Zone). When using a root domain, make sure to add the DNS Records from your registered Domain to the new Hosted Zone.
The Certificate Validation step can take a few Minutes.
