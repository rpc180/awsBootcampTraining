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
  source = "./modules/beanstalk"
}

module "cloudfront" {
  source = "./modules/cloudfront"
}