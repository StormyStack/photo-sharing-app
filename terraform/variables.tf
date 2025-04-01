variable "availability_zones" {
  type = list(string)
}

variable "my-ip" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "ami_id" {
  type = string
  default = "ami-071226ecf16aa7d96"
}

variable "dynamodb_table_name" {
  type = string
}