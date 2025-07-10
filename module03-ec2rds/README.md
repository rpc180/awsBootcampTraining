
# Module 03 – EC2 + RDS Platform with Terraform

This module deploys a basic AWS application platform consisting of:
- A Python-based wiki app (`wikiapp-en.zip`) on an EC2 instance
- A MySQL RDS backend
- A custom 3-subnet VPC (1 public, 2 private)
- Security group isolation between web and DB layers
- Optional data seeding and user-data customization

Designed for use with **AWS CloudShell**, but can also be run locally.

---

## 🧱 Project Structure

```
module03-ec2rds/
│
├── terraform.tfvars.example   # Populate this with your real values
├── user_data.sh               # EC2 instance bootstrap script
├── main.tf                    # Root module wiring
├── outputs.tf                 # Final outputs from all modules
├── modules/
│   ├── vpc/                   # VPC, subnets, route tables
│   ├── ec2/                   # EC2 instance, SG, SSH key
│   └── rds/                   # RDS instance, subnet group, SG
```

---

## ⚙️ Required Terraform Variables

Create a `terraform.tfvars` file (based on the `.example`) with:

```hcl
aws_region    = "us-east-2"
instance_type = "t3.micro"

# Your IP to allow SSH access (CIDR format)
my_ip         = "203.0.113.25/32"

# RDS MySQL credentials
db_name       = "wikiappdb"
db_username   = "admin"
db_password   = "YourSecurePassword123!"
```

---

## 🚀 Deploying with AWS CloudShell

AWS CloudShell already has Terraform installed and pre-authenticated with your AWS credentials. Follow these steps:

### 1. Launch CloudShell
- Click the CloudShell icon in the AWS Console (top bar).

### 2. Upload or Clone the Project
- Either upload a `.zip` or use Git:
  ```bash
  git clone https://github.com/your-username/your-repo.git
  cd your-repo/module03-ec2rds
  ```

### 3. Prepare Variables
Create your own `terraform.tfvars` file based on the provided example.

### 4. Initialize Terraform
```bash
cd wikiapp-terraform
terraform init
```

### 5. Review Plan
```bash
terraform plan -var-file="../terraform.tfvars"
```

### 6. Apply Infrastructure
```bash
terraform apply -var-file="../terraform.tfvars"
```

---

## 🔐 SSH Access to EC2

- The PEM file will be created automatically as `modules/ec2/wikiapp-key.pem`.
- SSH example:
  ```bash
  chmod 400 modules/ec2/wikiapp-key.pem
  ssh -i modules/ec2/wikiapp-key.pem ubuntu@<EC2_PUBLIC_IP>
  ```

---

## 📦 Additional Notes

- `user_data.sh` includes logic to:
  - Download and unzip the Python wiki app
  - Install system packages and Python dependencies
  - Wait for RDS to be ready before seeding (if configured)

- You can modify `user_data.sh` to inject SQL dumps, install Flask/MySQL libraries, or pull application code from Git/S3.

- The EC2 instance runs in the public subnet.
- The RDS instance is deployed across two private subnets in multi-AZ mode.

---

## 🧼 Cleanup

To destroy all infrastructure:

```bash
terraform destroy -var-file="../terraform.tfvars"
```

---

## 📚 Topics Covered

- Terraform module structure
- Secure EC2-RDS communication
- VPC design with public/private subnets
- CloudShell-based provisioning
- Remote access via key pair
