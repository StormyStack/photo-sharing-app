resource "aws_dynamodb_table" "photo_metadata" {
  name           = var.dynamodb_table_name
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "photo_id"
    type = "S"
  }

  attribute {
    name = "uploaded_at"
    type = "S"
  }

  hash_key = "photo_id"

  global_secondary_index {
    name            = "uploaded_at-index"
    hash_key        = "uploaded_at"
    range_key       = "photo_id"
    projection_type = "ALL"
  }

  tags = {
    Name        = "Photo MetaData Table"
    Environment = "Production"
  }
}
