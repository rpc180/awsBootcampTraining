resource "aws_dynamodb_table" "app_table" {
  name           = "users"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "email"
  attribute {
    name = "email"
    type = "S"
  }
  tags = {
    Name = "AppEmailTable"
  }
}