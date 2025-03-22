from flask import Flask, render_template, redirect, request, jsonify
import boto3
from werkzeug.utils import secure_filename
import os

app=Flask(__name__)
app.config.from_object('config.Config')

s3 = boto3.client('s3', aws_access_key_id=app.config['AWS_ACCESS_KEY'], aws_secret_access_key=app.config['AWS_SECRET_KEY'])

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/upload", methods=["POST"])
def upload_file():
    file = request.files["file"]
    if file:
        s3.upload_fileobj(file, S3_BUCKET_NAME, file.filename)
        return "File uploaded successfully!", 200
    return "No file uploaded!", 400

@app.route("/images")
def list_images():
    objects = s3.list_objects_v2(Bucket=S3_BUCKET_NAME).get("Contents", [])
    image_urls = [f"https://{S3_BUCKET_NAME}.s3.amazonaws.com/{obj['Key']}" for obj in objects]
    return jsonify(image_urls)

if __name__ == "__main__":
    app.run(debug=True)
