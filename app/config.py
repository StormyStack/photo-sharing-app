import boto3

def get_s3_bucket_name():
    s3 = boto3.client('s3')
    response = s3.list_buckets()
    return response['Buckets'][0]['Name']

def get_dynamodb_table_name():
    dynamodb = boto3.client('dynamodb')
    response = dynamodb.list_tables()
    return response['TableNames'][0]

class Config:
    S3_BUCKET_NAME = get_s3_bucket_name()
    DYNAMODB_TABLE_NAME = get_dynamodb_table_name()
