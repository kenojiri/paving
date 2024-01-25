variable "access_key_id" {
  type = string
}

variable "secret_access_key" {
  type = string
}

variable "session_token" {
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
