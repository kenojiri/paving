terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.65"
   }
    random = {
      source = "hashicorp/random"
    }
    tls = {
      source = "hashicorp/tls"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
    curl = {
      source  = "anschoewe/curl"
      version = "~> 1.0"
    }
  }
  required_version = "~> 1.0"
}
