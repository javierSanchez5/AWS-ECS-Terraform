module "rds-alarms" {
  source  = "lorenzoaiello/rds-alarms/aws"
  version = "2.2.0"
//required variables
  db_instance_id = aws_db_instance.challenge_dbi.id
  db_instance_class = aws_db_instance.challenge_dbi.instance_class
}