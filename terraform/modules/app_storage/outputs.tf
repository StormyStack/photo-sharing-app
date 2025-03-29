output "s3_bucket_name" {
  value = aws_s3_bucket.app_bucket.bucket
}

output "s3_object_key" {
  value = aws_s3_bucket_object.photo_app_zip.key
}
