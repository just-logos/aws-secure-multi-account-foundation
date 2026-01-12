############################
# Outputs
############################

# Export identifiers to easily verify resources and reference them in other configs

output "workload_vpc_id" {
  description = "ID of the workload VPC"
  value       = aws_vpc.workload.id
}

output "workload_private_subnet_ids" {
  description = "IDs of the workload private subnets"
  value       = aws_subnet.private[*].id
}


output "workload_private_subnet_cidrs" {
  description = "CIDR blocks of the workload private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "workload_private_route_table_id" {
  description = "ID of the workload private route table"
  value       = aws_route_table.private.id
}