output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

output "rds_endpoint" {
  description = "Endpoint address of the RDS MySQL instance"
  value       = module.rds.endpoint
}

output "ssh_private_key_path" {
  description = "Local path to the generated PEM file for EC2 SSH access"
  value       = module.ec2.pem_file_path
}