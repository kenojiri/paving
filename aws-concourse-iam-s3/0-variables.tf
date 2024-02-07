variable "sandbox_access_key_id" {
  type = string
}

variable "sandbox_secret_access_key" {
  type = string
}

variable "sandbox_session_token" {
  type = string
  default = ""
}

variable "prod_access_key_id" {
  type = string
}

variable "prod_secret_access_key" {
  type = string
}

variable "prod_session_token" {
  type = string
  default = ""
}

variable "region" {
  type = string
  description = "target AWS region."
}

variable "environment_name" {
  type = string
}
