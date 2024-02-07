variable "region" {
  type = string
  description = "target AWS region."
}

variable "environment_name" {
  type = string
  description = "This name is appended as a prefix to the subdomain for this environment."
}

variable "vpc_name" {
  type = string
  description = "The Platform Management Plane VPC name."
}

variable "subnet_ids" {
  type = list
  description = "The Platform Management Plane subnet IDs."
}

variable "elb_subnet_ids" {
  type = list
  description = "The Platform Management Plane subnet IDs for ELB."
}

variable "db_username" {
  type = string
  default = "dbadmin"
  description = "AWS RDS PostgreSQL username as admin."
}

variable "db_storage_in_gib" {
  type = number
  default = 20
  description = "AWS RDS PostgreSQL server storage in GiB."
}

variable "db_instance_class" {
  type = string
  default = "db.m4.large"
  description = "AWS RDS PostgreSQL instance class."
}
