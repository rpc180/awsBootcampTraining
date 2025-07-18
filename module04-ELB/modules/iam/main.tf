resource "aws_iam_role" "beanstalk_service_role" {
  name = "eb_service_role"
  assume_role_policy = data.aws_iam_policy_document.beanstalk_assume_role.json
}

data "aws_iam_policy_document" "beanstalk_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "attach_managed_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
    "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  ])
  role       = aws_iam_role.beanstalk_service_role.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "eb_ec2_instance_profile"
  role = aws_iam_role.beanstalk_service_role.name
}