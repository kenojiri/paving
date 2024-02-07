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
  region = var.region
}
