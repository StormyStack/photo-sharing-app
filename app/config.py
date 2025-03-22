import os
class Config:
    AWS_ACCESS_KEY=os.getenv('AWS_ACCESS_KEY_ID')
    AWS_SECRET_KEY=os.getenv('AWS_SECRET_ACCESS_KEY')
    S3_BUCKET_NAME=os.getenv('S3_BUCKET_NAME')
    FLASK_ENV='development'
    