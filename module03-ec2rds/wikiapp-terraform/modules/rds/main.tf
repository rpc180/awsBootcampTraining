resource "aws_security_group" "rds_sg" {
  name   = "wikiapp-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "wikiapp-subnet-group"
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "mysql" {
  identifier        = "wikiapp-db"
  engine            = "mysql"
  instance_class    = "db.t3.micro"
  username          = var.db_username
  password          = var.db_password
  db_name           = var.db_name
  allocated_storage = 20
  storage_type      = "gp2"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot    = true
  multi_az               = true
}

output "endpoint" {
  value = split(":", aws_db_instance.mysql.endpoint)[0]
}