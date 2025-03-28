output "main_vpc_id" {
  value = aws_vpc.main-vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "default_route_table_id" {
  value = aws_vpc.main-vpc.default_route_table_id
}