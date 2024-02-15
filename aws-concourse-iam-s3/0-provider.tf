terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
  required_version = "~> 1.0"
}

provider "aws" {
  alias      = "sandbox_account"
  region     = var.region
  access_key = var.sandbox_access_key_id
  secret_key = var.sandbox_secret_access_key
  token      = var.sandbox_session_token
}

provider "aws" {
  alias      = "nonprod_account"
  region     = var.region
  access_key = var.nonprod_access_key_id
  secret_key = var.nonprod_secret_access_key
  token      = var.nonprod_session_token
}

provider "aws" {
  alias      = "prod_account"
  region     = var.region
  access_key = var.prod_access_key_id
  secret_key = var.prod_secret_access_key
  token      = var.prod_session_token
}
