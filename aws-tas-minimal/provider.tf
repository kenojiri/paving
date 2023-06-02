provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "cloudflare" {
  #count = var.cloudflare_api_token == "" ? 0 : 1
  api_token = var.cloudflare_api_token
}

provider "acme" {
  server_url = var.acme_server_url
}