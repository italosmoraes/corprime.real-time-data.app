variable "aws_region" {
  default = "eu-west-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-009452531fa1056fa" # Amazon Linux 2 AMI for eu-west-1
}

variable "aws_account_id" {
  description = "Your AWS Account ID"
  type        = string
  default = null
}