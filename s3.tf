resource "aws_s3_bucket" "static" {
  bucket = "my-ppfa-tf-test-bucket"
  acl    = "public-read"

  tags = {
    Name = "static-content"
  }
}

variable "upload_directory" {
  default = "./static-content/"
}

variable "mime_types" {
  default = {
    htm   = "text/html"
    html  = "text/html"
    css   = "text/css"
    ttf   = "font/ttf"
    js    = "application/javascript"
    map   = "application/javascript"
    json  = "application/json"
  }
}

resource "aws_s3_bucket_object" "website_files" {
  for_each      = fileset(var.upload_directory, "**/*.*")
  bucket        = aws_s3_bucket.static.bucket
  key           = replace(each.value, var.upload_directory, "")
  source        = "${var.upload_directory}${each.value}"
  acl           = "public-read"
  etag          = filemd5("${var.upload_directory}${each.value}")
  #content_type  = lookup(local.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
}
