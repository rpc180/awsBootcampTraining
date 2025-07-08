# awsBootcampTraining
Scripts and Files associated with AWS bootcamps

---

## 🔐 Module 02 – IAM User Management with Python
This module walks through a script that automates IAM user provisioning and policy assignment using Python and Boto3, suitable for managing access in AWS environments with infrastructure-as-code workflows.

🔧 Topics Covered
- Automating IAM user creation and management
- Assigning inline and managed policies via scripting
- Secure handling of AWS credentials and permission boundaries
- Integrating IAM operations into IaC or DevOps pipelines

📂 Folder
module02-IAM

---

## 📦 Module 03 – EC2 + RDS Deployment with Terraform
This module demonstrates how to provision a simple Python-based wiki application hosted on an EC2 instance, backed by an RDS MySQL database, using Terraform and best practices for VPC design, security groups, and user data initialization.

🔧 Topics Covered
- Multi-subnet VPC with public/private subnet isolation
- EC2 bootstrap using user_data for dependency installation and app startup
- RDS MySQL provisioning with secure access from EC2 only
- Key pair generation and PEM output handling via Terraform
- Database seeding via SQL file from EC2
- CloudShell-compatible deployment and remote state preparation

📂 Folder
module03-ec2rds
