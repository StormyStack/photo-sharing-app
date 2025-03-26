resource "aws_dynamodb_table" "photo_metadata" {
  name = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"

 attribute {
   name = "photo_id"
   type = "S"
 }

 hash_key = "photo_id"

 attribute {
   name = "uploaded_at"
   type = "S"
 }

 tags = {
    Name = "Photo MetaData Table"
    Environment = "Production"
 }
}