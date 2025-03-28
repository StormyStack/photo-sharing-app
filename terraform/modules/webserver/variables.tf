variable "image_name" {
  type = string
  default = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
}

variable "public_key_location" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "subnet_id" {

}

variable "ec2_sg_id" {

}

variable "ec2_iam_profile_name" {
  type = string
}

variable "alb_target_group_arn" {
  
}