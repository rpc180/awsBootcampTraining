provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/vpc"
}

module "ec2" {
  source         = "./modules/ec2"
  vpc_id         = module.network.vpc_id
  public_subnet  = module.network.public_subnet_id
  key_name       = var.key_name
  instance_type  = var.instance_type
  wikiapp_zip    = var.wikiapp_zip
  my_ip          = var.my_ip
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  rds_endpoint = module.rds.endpoint
}

module "rds" {
  source            = "./modules/rds"
  vpc_id            = module.network.vpc_id
  private_subnets   = module.network.private_subnet_ids
  ec2_security_group_id = module.ec2.security_group_id
  db_username       = var.db_username
  db_password       = var.db_password
  db_name           = var.db_name
}