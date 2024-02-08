terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
    curl = {
      source = "anschoewe/curl"
    }
  }
  required_version = "~> 1.0"
}

provider "aws" {
  alias = "base"
  region = var.region
}

provider "aws" {
  alias = "target"
  region = var.region
  assume_role {
    role_arn = var.assuming_role_arn
  }
}
