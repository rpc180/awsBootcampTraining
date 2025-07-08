variable "aws_region" {
  default = "us-east-2"
}

variable "key_name" {}
variable "instance_type" {
  default = "t2.micro"
}
variable "wikiapp_zip" {}
variable "my_ip" {}
variable "db_username" {}
variable "db_password" {}
variable "db_name" {}