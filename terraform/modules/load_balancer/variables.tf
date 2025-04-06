variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_name" {
  type = string
  default = "my-photosharing-alb"
}

variable "vpc_id" {
  type = string
}

variable "alb-sg_id" {
}