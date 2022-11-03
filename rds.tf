
/*resource "random_string" "challenge-db-password" {
  length  = 8
  upper   = true
  numeric = true
  special = false
}*/

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
  //password               = random_string.challenge-db-password.result
  password = "xstrongDrSp"
}
/*
resource "aws_db_instance" "challenge_replica" {
  identifier             = "challenge-replica"
  replicate_source_db    = aws_db_instance.challenge_dbi.identifier ## refer to the master instance
  db_name                   = "test_ead"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.1"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  username = ""
  password = ""
  backup_retention_period = 1
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
}*/

/*resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "credentials"
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id     = aws_secretsmanager_secret.rds_credentials.id
  secret_string = random_string.challenge-db-password.result
}
*/