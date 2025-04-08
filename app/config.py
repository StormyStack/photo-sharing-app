import os

class Config:
    S3_BUCKET_NAME = os.getenv('s3_bucket_name')
    DYNAMODB_TABLE_NAME = "photo_metadata"
    AWS_REGION = "us-east-1"
