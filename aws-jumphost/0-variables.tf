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

variable "availability_zone" {
  type = string
  description = "The availability zone to use. Must belong to the provided region."
}

variable "ec2_ssh_key_pair_name" {
  type = string
  description = "Existing EC2 SSH key pair name in the region."
}
