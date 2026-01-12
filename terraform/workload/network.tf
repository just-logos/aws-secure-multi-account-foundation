############################
# Avaiability Zones
############################

# Query AWS for all available AZs in the current region
# Dynamically to avoid hardcoding AZ names

data "aws_availability_zones" "available" {
  state = "available"
}

############################
# Local Design Decisions
############################

# Architectural decision: create two private subnets to support high availability across multiple AZs
# Defining the subnet count here provides a single place to change this decision later if needed
locals {
  private_subnet_count = 2
}

############################
# Private Subnets
############################

# Create private subnets inside workload VPC using 
resource "aws_subnet" "private" {
  count = local.private_subnet_count

  # Attach subnets to workload VPC
  vpc_id = aws_vpc.workload.id

  # Attach subnets across AZs dynamically using index
  availability_zone = data.aws_availability_zones.available.names[count.index]

  # Split 10.0.0.0/16 into /24 subnets
  # index 0 -> 10.0.0.0/24
  # index 1 -> 10.0.0.1/24
  cidr_block = cidrsubnet(
    aws_vpc.workload.cidr_block,
    8,
    count.index
  )

  # Ensure instances launched in this resource block do not receive public IPs
  map_public_ip_on_launch = false

  tags = {
    Name = "workload-private-az${count.index + 1}"
    Tier = "private"
  }
}

############################
# Private Route Table
############################

# Route table for private subnets
# No default route to an Internet Gateway or NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.workload.id

  tags = {
    Name = "workload-private-rt"
    Tier = "private"
  }

}

############################
# Route Table Associations
############################

# Associate private route table with each private subnet
# Ensures all private subnets use the same routing rules
resource "aws_route_table_association" "private" {
  count = local.private_subnet_count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}