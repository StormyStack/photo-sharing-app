resource "aws_s3_bucket" "photo" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "photo_bucket_block" {
  bucket = aws_s3_bucket.photo.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "photo_bucket_policy" {
  bucket = aws_s3_bucket.photo.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
              aws_s3_bucket.photo.arn,
              "${aws_s3_bucket.photo.arn}/*"
            ]
        }
    ]
})
  depends_on = [aws_s3_bucket_public_access_block.photo_bucket_block]
}