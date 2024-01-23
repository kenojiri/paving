terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = "~> 3.65"
   }
  }
  required_version = "~> 1.0"
}

provider "aws" {
  region     = var.region
  access_key = var.access_key_id
  secret_key = var.secret_access_key
  token      = var.session_token
}
