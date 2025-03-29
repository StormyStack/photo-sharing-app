resource "aws_s3_bucket" "app_bucket" {
  bucket = var.app_bucket_name
}

resource "aws_s3_bucket_object" "photo_app_zip" {
  bucket = aws_s3_bucket.app_bucket.bucket
  key    = "photo-sharing-app.zip"
  source = var.app_zip_path
  acl = "private" 
}
