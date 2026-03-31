#s3 bucket for my tf state
resource "aws_s3_bucket" "ekstfstate" {
  bucket = "ekstfstate786"

  tags = {
    Name = "eks bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.ekstfstate.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.ekstfstate.id


  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.ekstfstate.id
  versioning_configuration {
    status = "Enabled"
  }
} 