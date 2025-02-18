output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.main.id
}

output "db_subnet_ids" {
  description = "The DB Tier Subnets"
  value = [
    aws_subnet.db_sub_1.id,
    aws_subnet.db_sub_2.id
  ]
}

output "app_tier_subnet_ids" {
  description = "The App Tier Subnets"
  value = [
    aws_subnet.app_sub_1.id,
    aws_subnet.app_sub_2.id
  ]
}