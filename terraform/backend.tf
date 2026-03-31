terraform {
  backend "s3" {
    bucket         = "ekstfstate786"
    key            = "path/to/my/key"
    region         = "eu-west-2"
    dynamodb_table = "eksstatelock"

  }
}