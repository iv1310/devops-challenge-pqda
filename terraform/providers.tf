terraform {
  required_version = ">= 1.5.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.27"
    }
  }
}

provider "aws" {
  profile = "aws-uwU"
  region = "us-east-1"

  default_tags {
    tags = {
      CreatedBy = "Terraform"
    }
  }
}

backend "s3" {
  bucket         = "uwu-db-state"
  key            = "uwu-db-terraform.tfstate"
  region         = "us-east-1"
  encrypt        = true
  dynamodb_table = "uwu-db-table"
  profile        = "aws-uwU"
}
