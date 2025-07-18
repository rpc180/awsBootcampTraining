provider "aws" {
  region = var.aws_region
}

module "iam" {
  source = "./modules/iam"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "beanstalk" {
  aws_region        = var.aws_region
  app_zip_url       = var.app_zip_url
  ec2_key_pair_id   = var.ec2_key_pair_id
  security_group_id = var.security_group_id
}

module "cloudfront" {
  source = "./modules/cloudfront"
}