from flask import Flask, render_template, request, jsonify
import boto3
from werkzeug.utils import secure_filename
import os
import uuid
from datetime import datetime
from config import Config

application = Flask(__name__)
application.config.from_object(Config)

S3_BUCKET_NAME = application.config["S3_BUCKET_NAME"]
DYNAMODB_TABLE_NAME = application.config["DYNAMODB_TABLE_NAME"]

s3 = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(DYNAMODB_TABLE_NAME)

@application.route("/")
def index():
    return render_template("index.html")

@application.route("/upload", methods=["POST"])
def upload_file():
    file = request.files["file"]
    if file:
        filename = secure_filename(file.filename)
        photo_id = str(uuid.uuid4())
        s3_key = f"{photo_id}_{filename}"
        photo_url = f"https://{S3_BUCKET_NAME}.s3.amazonaws.com/{s3_key}"

        s3.upload_fileobj(file, S3_BUCKET_NAME, s3_key, ExtraArgs={"ACL": "public-read"})

        table.put_item(
            Item={
                "photo_id": photo_id,
                "photo_url": photo_url,
                "uploaded_at": datetime.utcnow().isoformat(),
            }
        )

        return "File uploaded successfully!", 200
    return "No file uploaded!", 400

@application.route("/images")
def list_images():
    response = table.scan()
    items = response.get("Items", [])
    
    image_urls = [{"photo_url": item["photo_url"], "uploaded_at": item["uploaded_at"]} for item in items]
    return jsonify(image_urls)

@application.route("/health")
def health_check():
    return "OK", 200

if __name__ == "__main__":
    application.run(port=5000,debug=True)
