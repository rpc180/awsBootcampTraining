# WikiApp Terraform Infrastructure

This repository contains Terraform code to deploy a Python-based wiki application on AWS, using:

- EC2 for hosting the application
- RDS MySQL for backend storage
- A custom VPC with public/private subnet isolation
- EC2 bootstrap logic to install packages and seed the MySQL database

## 📁 Structure

```
.
├── main.tf
├── variables.tf
├── terraform.tfvars.example
├── .gitignore
├── README.md
├── modules/
│   ├── vpc/
│   ├── ec2/
│   │   └── user_data.sh
│   └── rds/
└── scripts/
    └── init.sql
```

## 🚀 How to Use (from AWS CloudShell)

```bash
# Download and extract the latest release
wget https://github.com/yourusername/wikiapp-terraform/archive/refs/heads/main.zip -O project.zip
unzip project.zip
cd wikiapp-terraform-main

# Initialize Terraform and apply
terraform init
terraform plan
terraform apply
```

## 🔐 Secrets

- Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in your values.
- Do NOT commit `terraform.tfvars` or `.pem` files to version control.

## 📦 Required

- Terraform 1.x
- AWS CLI or AWS CloudShell