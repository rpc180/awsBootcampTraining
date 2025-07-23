provider "aws" {
  region = var.aws_region
}

module "iam" {
  source = "./modules/iam"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "eb_ec2_instance_profile"
  role = module.iam.beanstalk_service_role_name
}

module "beanstalk" {
  source             = "./modules/beanstalk"
  aws_region         = var.aws_region
  app_zip_url        = var.app_zip_url
  ec2_key_pair_id    = var.ec2_key_pair_id
  security_group_id  = var.security_group_id
  iam_instance_profile = module.iam.ec2_instance_profile_name

  depends_on = [null_resource.make_script_executable]
}

module "cloudfront" {
  source = "./modules/cloudfront"
  eb_endpoint_url = module.beanstalk.beanstalk_env_url
}

resource "null_resource" "make_script_executable" {
  provisioner "local-exec" {
    command = "chmod +x scripts/get_latest_python_platform.sh"
  }

  triggers = {
    script_hash = filesha1("${path.module}/scripts/get_latest_python_platform.sh")
  }
}