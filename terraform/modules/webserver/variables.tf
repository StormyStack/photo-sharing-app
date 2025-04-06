variable "public_key_location" {
  type = string
  default = "~/.ssh/id_rsa.pub"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "subnet_ids" {
  type = list(string)
}

variable "ec2_sg_id" {

}

variable "ec2_iam_profile_name" {
  type = string
}

variable "alb_target_group_arn" {

}

variable "ami_id" {
  type = string
}