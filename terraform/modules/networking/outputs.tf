output "main_vpc_id" {
  value = aws_vpc.main-vpc.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for subnet in aws_subnet.public_subnet : subnet.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for subnet in aws_subnet.private_subnet : subnet.id]
}

output "default_route_table_id" {
  value = aws_vpc.main-vpc.default_route_table_id
}