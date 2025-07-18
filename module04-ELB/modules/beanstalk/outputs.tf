
output "beanstalk_env_url" {
  value = aws_elastic_beanstalk_environment.env.endpoint_url
}
