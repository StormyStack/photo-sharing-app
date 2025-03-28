from flask import Flask, render_template, request, jsonify
import boto3
from werkzeug.utils import secure_filename
import os
import uuid
from datetime import datetime

app = Flask(__name__)
app.config.from_object("config.Config")

S3_BUCKET_NAME = app.config["S3_BUCKET_NAME"]
DYNAMODB_TABLE_NAME = app.config["DYNAMODB_TABLE_NAME"]

s3 = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(DYNAMODB_TABLE_NAME)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/upload", methods=["POST"])
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

@app.route("/images")
def list_images():
    response = table.scan()
    items = response.get("Items", [])
    
    image_urls = [{"photo_url": item["photo_url"], "uploaded_at": item["uploaded_at"]} for item in items]
    return jsonify(image_urls)

if __name__ == "__main__":
    app.run(debug=True)
