# Elastic Beanstalk + CloudFront + DynamoDB Terraform Project

## Overview

This project sets up an AWS Elastic Beanstalk environment with a CloudFront distribution, backed by a DynamoDB table. IAM roles and instance profiles are created for EC2 and Elastic Beanstalk access.

## Components

- Elastic Beanstalk (Python platform)
- CloudFront (fronts Elastic Beanstalk ELB)
- DynamoDB (with email as primary key)
- IAM roles and policies
- EC2 key pair reference
- Auto-scaling and load balancing

## Usage

1. Update `terraform.tfvars` with your actual values.
2. Run the following in AWS CloudShell or locally:

```bash
terraform init
terraform plan
terraform apply
```

## Notes

- Make sure the EC2 key pair and security group already exist in your account.
- Ensure the zip file URL is publicly accessible or permissioned correctly for Beanstalk access.