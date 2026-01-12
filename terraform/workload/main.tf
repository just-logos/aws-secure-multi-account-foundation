############################
# Workload VPC
############################

# Primary VPC for workload resources
resource "aws_vpc" "workload" {
  # Use a /16 CIDR from RFC1918 private address space
  cidr_block = "10.0.0.0/16"

  # Enable DNS support and hostnames for resources within the VPC
  enable_dns_support   = true
  enable_dns_hostnames = true

  # Human readable tags for the VPC
  # Additonal tags are applied automatically via the provider configuration
  tags = {
    Name = "workload-vpc"
  }
}