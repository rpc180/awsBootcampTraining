resource "aws_security_group" "ec2_sg" {
  name        = "wikiapp-ec2-sg"
  description = "Allow SSH from my IP and HTTP from anywhere"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from cloudshell"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_instance" "wikiapp" {
  ami                    = "ami-0557a15b87f6559cf"  # ✅ Ubuntu 22.04
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.generated_key.key_name

user_data = templatefile("${path.root}/user_data.sh", {
  rds_endpoint = var.rds_endpoint
  db_username  = var.db_username
  db_password  = var.db_password
  db_name      = var.db_name
})

  tags = {
    Name = "wikiapp-ec2"
  }
}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/wikiapp-key.pem"
  file_permission = "0400"
}

output "public_ip" {
  value = aws_instance.wikiapp.public_ip
}

output "security_group_id" {
  value = aws_security_group.ec2_sg.id
}

output "pem_file_path" {
  value = local_file.private_key.filename
}