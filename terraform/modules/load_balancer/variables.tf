variable "public_subnet_id" {
  type = string
}

variable "alb_name" {
  type = string
  default = "my_photosharing_alb"
}

variable "vpc_id" {
  type = string
}