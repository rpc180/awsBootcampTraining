variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "app_zip_url" {
  description = "S3 URL for the Elastic Beanstalk application zip"
  type        = string
}

variable "ec2_key_pair_id" {
  description = "Existing EC2 key pair ID"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for EC2 instances"
  type        = string
}