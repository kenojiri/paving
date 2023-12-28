provider "aws" {
  region     = var.region
  access_key = var.access_key_id
  secret_key = var.secret_access_key
  token      = var.session_token
}

provider "acme" {
  server_url = var.acme_server_url
}
