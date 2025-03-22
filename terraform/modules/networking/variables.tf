variable "vpc_cidr_block" {
  type = string
}

variable "env_prefix" {
  type = string
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "default_route_table_id" {
  type = string
}