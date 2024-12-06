# Terraform Configuration for a S3 Bucket with Cloudfront

## `terraform init`

Add your `domain_name`, `project_name` and `env` to the variables.tf file and supply the name of the S3 Bucket that should contain the Terraform state in the Terraform backend in main.tf.

## `terraform apply`

You have to manually add the DNS Records from the created Hosted Zone to your registered Domain DNS entries (Route53) when reaching the `module.route53.aws_acm_certificate_validation.cert_validation: Still creating...` task.

If working with Subodmains make sure to add the correct DNS Records to the main Hosted Zone (for example add `dev.yourdomain.de` as a NS Record to the `yourdomain.de` Hosted Zone and add the NS Entries that were automatically generated from AWS from your `dev.yourdomain.de` hosted Zone).
The Certificate Validation step can take a few Minutes.

## Use Modules as Git Sources

To use the Modules from this Repo in another Repo simply copy the `example.main.tf` as `main.tf` inside your new Repo and add the `variables.tf` with your values to it. Remember to set the S3 Backend in your main.tf correctly.

## Connecting AWS with Github Actions

To connect AWS with Github Actions we need to create an identity provider for github actions: https://github.com/ChristianHesels/infra

Afterwards this identity provider needs a policy and a role. This can be done by using the iam Configuration as a module.

Add the created AWS Role as AWS_ROLE Variable to Github Actions.

The Github Workflow could look like this:

```yaml
name: Deploy

permissions:
  id-token: write
  contents: read

on:
  push:
    branches:
      - main
      - dev

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install dependencies
        run: npm ci

      - name: Build project
        run: npm run build

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE }}
          aws-region: eu-central-1

      - name: Deploy to Prod
        if: github.ref == 'refs/heads/main'
        run: |
          aws s3 sync ./build/. s3://${{ vars.PROD_S3_NAME}}
          aws cloudfront create-invalidation --distribution-id ${{ secrets.PROD_DISTRIBUTION_ID }} --paths "/*"

      - name: Deploy to Dev
        if: github.ref == 'refs/heads/dev'
        run: |
          aws s3 sync ./build/. s3://${{ vars.DEV_S3_NAME }}
          aws cloudfront create-invalidation --distribution-id ${{ secrets.DEV_DISTRIBUTION_ID }} --paths "/*"
```
