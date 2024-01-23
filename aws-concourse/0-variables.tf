variable "region" {
  type = string
  description = "target AWS region."
}

variable "environment_name" {
  type = string
  description = "This name is appended as a prefix to the subdomain for this environment."
}

variable "vpc_cidr" {
  type = string
  default = "172.30.0.0/16"
  description = "The CIDR for subnets."
}

variable "private_subnet_cidrs" {
  type = list
  default = ["172.30.1.0/24","172.30.2.0/24"]
  description = "The CIDR for subnets."
}

variable "availability_zones" {
  type = list
  description = "The availability zone to use. Must belong to the provided region."
}

variable "base_domain" {
  type = string
  description = "base domain name (e.g. example.com)"
}

variable "use_rds" {
  type = bool
  default = true
  description = "If this variable is 'true', AWS RDS MySQL instance will be created."
}

variable "db_username" {
  type = string
  default = "dbadmin"
  description = "AWS RDS PostgreSQL username as admin."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Key/value tags to assign to all resources."
}
