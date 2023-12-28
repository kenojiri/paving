variable "region" {
  type = string
  description = "target AWS region."
}

variable "access_key_id" {
  type = string
  default = ""
}

variable "secret_access_key" {
  type = string
  default = ""
}

variable "session_token" {
  type = string
  default = ""
}

variable "base_domain" {
  type = string
  description = "base domain name (e.g. example.com)"
}

variable "environment_name" {
  type = string
  description = "This name is appended as a prefix to the subdomain for this environment."
}

variable "primary_availability_zone" {
  type = string
  description = "The availability zone to use. Must belong to the provided region."
}

variable "secondary_availability_zone" {
  type = string
  description = "The secondary availability zone to use. Must belong to the provided region."
}

variable "ec2_ssh_key_pair_name" {
  type = string
  description = "Existing EC2 SSH key pair name in the region."
}

variable "email_address" {
  type = string
  description = "Email address for requesting Let's Encrypt certs."
}

variable "use_rds" {
  type = bool
  default = true
  description = "If this variable is 'true', AWS RDS MySQL instance will be created."
}

### deeper customization

variable "acme_server_url" {
  type = string
  default = "https://acme-v02.api.letsencrypt.org/directory"
  description = "default value is for Let's Encrypt production. can be changed if you want to use Lets' Encrypt staging or another ACME server"
}

variable "primary_private_subnet_cidr" {
  type        = string
  default     = "172.31.200.0/24"
  description = "The CIDR for the Private subnet in primary AZ."
}

variable "secondary_private_subnet_cidr" {
  type        = string
  default     = "172.31.201.0/24"
  description = "The CIDR for the Private subnet in secondary AZ."
}

variable "opsman_allowed_cidrs" {
  type        = list
  default     = ["0.0.0.0/0"]
  description = "CIDRs allowed to communicate with Ops Manager."
}

variable "opsman_instance_type" {
  type        = string
  default     = "t3.large"
  description = "EC2 instance type of OpsManager."
}

variable "opsman_boot_disk_size_in_gb" {
  type        = number
  default     = 100
  description = "OpsManager root disk size in GB."
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
