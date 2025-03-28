variable "vpc_id" {
  type = string
}

variable "env_prefix" {
  type = string
  default = "Deployment"
}

variable "my-ip" {
  type = string
}

variable "s3_bucket_arn" {
  type = string
}

variable "dynamodb_arn" {
  type = string
}