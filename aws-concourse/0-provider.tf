terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "~> 3.65"
    }
    random = {
      source = "hashicorp/random"
    }
    #tls = {
    #  source = "hashicorp/tls"
    #}
    #acme = {
    #  source = "vancluever/acme"
    #  #version = "~> 2.0"
    #}
    curl = {
      source = "anschoewe/curl"
      #version = "~> 1.0"
    }
  }
  required_version = "~> 1.0"
}

provider "aws" {
  region = var.region
}

#provider "acme" {
#  server_url = var.acme_server_url
#}
