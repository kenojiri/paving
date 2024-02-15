variable "region" {
  type = string
  description = "target AWS region."
}

variable "assuming_role_arn" {
  type = string
  description = "IAM role to be assumed for this Terraform script."
}

variable "environment_name" {
  type = string
  description = "This name is appended as a prefix to the subdomain for this environment."
}

variable "vpc_name" {
  type = string
  description = "The Foundation VPC name."
}

variable "subnet_ids" {
  type = list
  description = "The Foundation PCFAPPS subnet IDs."
}

variable "elb_subnet_ids" {
  type = list
  description = "The Foundation subnet IDs for ELB."
}

variable "platform_management_vpc_name" {
  type = string
  description = "The Platform Management Plane VPC name."
}

variable "https_listener_cert_secret_arn" {
  type = string
  description = "AWS Secrets Manager secret ARN of TLS ceritficate configured in HTTPS listener of Application Load Balancer for TAS."
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
