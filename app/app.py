from flask import Flask, render_template, request, jsonify
import boto3
from werkzeug.utils import secure_filename
import uuid
from datetime import datetime
from config import Config

application = Flask(__name__)
application.config.from_object(Config)

S3_BUCKET_NAME = application.config["S3_BUCKET_NAME"]
DYNAMODB_TABLE_NAME = application.config["DYNAMODB_TABLE_NAME"]
AWS_REGION = application.config["AWS_REGION"]

s3 = boto3.client("s3", region_name=AWS_REGION)
dynamodb = boto3.resource("dynamodb", region_name=AWS_REGION)
table = dynamodb.Table(DYNAMODB_TABLE_NAME)

@application.route("/")
def index():
    return render_template("index.html")

@application.route("/upload", methods=["POST"])
def upload_file():
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded!"}), 400
    
    files = request.files.getlist("file")
    if not files or all(f.filename == "" for f in files):
        return jsonify({"error": "No file selected!"}), 400
    
    uploaded_urls = []
    try:
        for file in files:
            if file and file.filename:
                filename = secure_filename(file.filename)
                photo_id = str(uuid.uuid4())
                s3_key = f"{photo_id}_{filename}"
                photo_url = f"https://{S3_BUCKET_NAME}.s3.amazonaws.com/{s3_key}"
                s3.upload_fileobj(file, S3_BUCKET_NAME, s3_key)
                table.put_item(
                    Item={
                        "photo_id": photo_id,
                        "photo_url": photo_url,
                        "uploaded_at": datetime.utcnow().isoformat(),
                    }
                )
                uploaded_urls.append(photo_url)
        return jsonify({
            "message": f"{len(uploaded_urls)} file{'s' if len(uploaded_urls) > 1 else ''} uploaded successfully!",
            "photo_urls": uploaded_urls
        }), 200
    except Exception as e:
        return jsonify({"error": f"Upload failed: {str(e)}"}), 500

@application.route("/images")
def list_images():
    try:
        response = table.scan()
        items = response.get("Items", [])
        image_urls = [{"photo_url": item["photo_url"], "uploaded_at": item["uploaded_at"]} for item in items]
        return jsonify(image_urls)
    except Exception as e:
        return jsonify({"error": f"Failed to fetch images: {str(e)}"}), 500

@application.route("/health")
def health_check():
    return "OK", 200

if __name__ == "__main__":
    application.run(host="0.0.0.0", port=5000, debug=True)