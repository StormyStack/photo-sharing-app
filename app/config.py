import os

class Config:
    S3_BUCKET_NAME = os.getenv("S3_BUCKET_NAME", "default-s3-bucket-name")
    DYNAMODB_TABLE_NAME = os.getenv("DYNAMODB_TABLE_NAME", "default-dynamodb-table-name")
