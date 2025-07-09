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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "wikiapp" {
  ami                    = "ami-053b0d53c279acc90"  # ✅ Ubuntu 22.04
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3 unzip
              cd /home/ec2-user
              unzip /tmp/wikiapp-en.zip -d wikiapp
              cd wikiapp
              python3 app.py &
              EOF

  tags = {
    Name = "wikiapp-ec2"
  }
}

resource "aws_s3_object" "wikiapp_zip" {
  bucket = "your-bucket-name"
  key    = "wikiapp-en.zip"
  source = var.wikiapp_zip
}

output "public_ip" {
  value = aws_instance.wikiapp.public_ip
}

output "security_group_id" {
  value = aws_security_group.ec2_sg.id
}