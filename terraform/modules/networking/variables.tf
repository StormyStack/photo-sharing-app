variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "env_prefix" {
  type = string
  default = "Deployment"
}

variable "public_subnet_cidr" {
  type = list(string)
  default = [ "10.0.1.0/24","10.0.2.0/24" ]
}

variable "private_subnet_cidr" {
  type = list(string)
  default = [ "10.0.3.0/24","10.0.4.0/24" ]
}

variable "availability_zones" {
  type = list(string)
}

variable "default_route_table_id" {
  type = string
}