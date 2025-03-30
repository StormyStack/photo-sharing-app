variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "eb_sg_id" {
  type = string
}

variable "beanstalk_iam_profile_name" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "app_version" {
  type = string
}

variable "s3_object_key" {
  type = string
}

variable "app_bucket_name" {
  type = string
  description = "Where the app stores"
}

variable "photo_app_version_description" {
  type = string
}