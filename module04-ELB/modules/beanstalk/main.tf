data "aws_elastic_beanstalk_solution_stack" "python_latest" {
  name_regex = "^64bit Amazon Linux 2 .* Python 3.*"
  most_recent = true
}

variable "aws_region" {}
variable "app_zip_url" {}
variable "ec2_key_pair_id" {}
variable "security_group_id" {}
variable "iam_instance_profile" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_key_pair" "imported" {
  key_name = "PersistentKeyPair"
}

resource "aws_elastic_beanstalk_application" "app" {
  name        = "eb-app"
  description = "Elastic Beanstalk app for web app"
}

resource "aws_elastic_beanstalk_environment" "env" {
  name                = "eb-env"
  application         = aws_elastic_beanstalk_application.app.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.python_latest.name
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = var.ec2_key_pair_id
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.iam_instance_profile
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeType"
    value     = "gp2"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeSize"
    value     = "10"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = data.aws_vpc.default.id
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", data.aws_subnets.default.ids)
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "2"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "4"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }
  setting {
    namespace = "aws:cloudwatch:metrics"
    name      = "EnhancedHealthReporting"
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_REGION"
    value     = var.aws_region
  }

  version_label = "v1"
}

resource "aws_elastic_beanstalk_application_version" "app_version" {
  lifecycle {
    ignore_changes = [source_bundle]
  }
  name        = "v1"
  application = aws_elastic_beanstalk_application.app.name
  description = "Initial version"  
}