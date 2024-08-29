variable "environment_name" {
  type = string
}

variable "base_domain" {
  description = "base domain name (e.g. example.com.). If variable 'cloudflare_api_key' is blank, this is used for AWS Route53 zone name."
  type = string
}

variable "region" {
  type = string
}

variable "availability_zone" {
  description = "The availability zone to use. Must belong to the provided region."
  type = string
}

variable "secondary_availability_zone" {
  description = "The secondary availability zone to use. Must belong to the provided region."
  type = string
}

variable "ec2_ssh_key_pair_name" {
  description = "Existing EC2 SSH key pair name. If this variable is blank, new SSH key pair is generated."
  default = ""
  type = string
}

variable "ssl_certificate" {
  description = "If this variable is blank, server cert will be automatically issued by Let's Encrypt."
  default = ""
  type = string
}

variable "ssl_private_key" {
  default = ""
  type = string
}

variable "email" {
  description = "used for Let's Encrypt"
  default = ""
  type = string
}

variable "use_rds" {
  description = "If this variable is 'true', AWS RDS MySQL instance will be created."
  default = true
  type = bool
}

### deeper customization

variable "db_username" {
  default = "tas"
  type = string
}

variable "public_subnet_cidr" {
  default     = "10.0.0.0/24"
  description = "The CIDR for the Public subnet."
  type        = string
}

variable "private_subnet_cidr" {
  default     = "10.0.1.0/24"
  description = "The CIDR for the Private subnet."
  type        = string
}

variable "secondary_private_subnet_cidr" {
  default     = "10.0.2.0/24"
  description = "The CIDR for the secondary Private subnet."
  type        = string
}

variable "ops_manager_allowed_ips" {
  description = "IPs allowed to communicate with Ops Manager."
  default     = ["0.0.0.0/0"]
  type        = list
}

variable "tags" {
  description = "Key/value tags to assign to all resources."
  default     = {}
  type        = map(string)
}

variable "acme_server_url" {
  default = "https://acme-v02.api.letsencrypt.org/directory"
  type = string
}
