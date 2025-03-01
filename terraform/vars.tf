variable "aws-region" {
  description = "Region where the ec2 will be deployed"
  type = string
}

variable "default-profile" {
  description = "Default profile for aws"
  type = string
  default = "default"
}
variable "Root_Passphrase" {
  type = string
  default = ""
}

variable "Root_CA_Name" {
  type = string
  default = ""
}

