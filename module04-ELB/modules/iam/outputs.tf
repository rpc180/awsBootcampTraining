
output "beanstalk_service_role_name" {
  value = aws_iam_role.beanstalk_service_role.name
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_instance_profile.name
}