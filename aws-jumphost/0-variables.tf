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

variable "jumphost_vpc_name" {
  type = string
  description = "name of VPC connected by Jumphost."
}

variable "jumphost_subnet_name" {
  type = string
  description = "name of subnet connected by Jumphost."
}

variable "ec2_ssh_key_pair_name" {
  type = string
  description = "Existing EC2 SSH key pair name in the region."
}
