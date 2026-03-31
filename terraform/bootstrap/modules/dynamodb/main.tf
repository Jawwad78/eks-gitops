resource "aws_dynamodb_table" "eks_dynamodb" {
  name         = "eksstatelock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
} 