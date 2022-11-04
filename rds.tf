
resource "aws_db_instance" "challenge_dbi" {
  identifier             = "challenge"
  db_name                = "test_ead"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.1"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.id
  username               = "postgresAdmin"
  password               = "xstrrngDrSp"
}

