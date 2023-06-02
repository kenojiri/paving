provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "cloudflare" {
  email = var.email
  api_key = var.cloudflare_api_key
}

provider "acme" {
  server_url = var.acme_server_url
}
