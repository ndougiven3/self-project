terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.77"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "self-project"

    workspaces {
      name = "prod"
    }
  }
}

provider "aws" {
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::${var.account_id}:role/application_deployment_role"
    session_name = "TERRAFORM_${uuid()}"
  }
}
