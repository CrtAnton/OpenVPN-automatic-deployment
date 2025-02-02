terraform {
    required_version = "~> 1.10.3"
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "5.82.2"
      }
    }
}

provider "aws" {
    region = var.aws-region
    profile = var.default-profile
}