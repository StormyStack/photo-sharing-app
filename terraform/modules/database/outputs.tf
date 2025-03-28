output "dynamodb_table_name" {
  value = aws_dynamodb_table.photo_metadata.name
}

output "dynamodb_arn" {
  value = aws_dynamodb_table.photo_metadata.arn
}