resource "aws_db_instance" "rs-rds" {
  allocated_storage    = var.storage
  db_name              = "mydb"
  engine               = var.engine
  engine_version       = var.engine-version
  instance_class       = var.instance_class
  username             = "rujwal"
  password             = "password"
  skip_final_snapshot  = true
}

resource "aws_security_group" "rs-example" {
  name_prefix = "rds-db"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}