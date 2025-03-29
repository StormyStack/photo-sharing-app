variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_name" {
  type = string
  default = "my-photosharing-alb"
}

variable "alb_sg_id" {
  type = string
}

variable "vpc_id" {
  type = string
}