#configure backend

terraform {
  backend "s3" {
    bucket         = "myterraformbucket4534-prod"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bucket-state-dynamodb-table"
  }
}
#dynamoDB for the bucket
resource "aws_dynamodb_table" "terraform_locks" {
  name           = "bucket-dynamodb-table-${terraform.workspace}"
  billing_mode   = "PROVISIONED"
  read_capacity  = "5"
  write_capacity = "5"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
