resource "aws_s3_bucket" "static" {
  bucket = "my-ppa-tf-test-bucket"
  acl    = "public-read"

  tags = {
    Name = "static-content"
  }
}

