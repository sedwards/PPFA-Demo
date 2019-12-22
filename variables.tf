variable "aws_access_key" {
  description = "AWS region to launch servers."
  default = "AWS_ACCESS_KEY_INPUT"
}

variable "aws_secret_key" {
  description = "AWS region to launch servers."
  default = "AWS_SECRET_KEY_INPUT"
}

variable "public_key_path" { 
  default = "ssh/terraform.pub" 
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "terraform2"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-1"
}

variable "aws_amis" {
  default = {
      us-west-1 = "ami-0b2d8d1abb76a53d8" # Amazon Linux
  }
}
