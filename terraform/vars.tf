variable "aws-region" {
  description = "Region where the ec2 will be deployed"
  type = string
}

variable "default-profile" {
  description = "Default profile for aws"
  type = string
  default = "default"
}