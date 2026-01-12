############################
# Local Design Decisions
############################

# Define allowed CIDR blocks for VPC Endpoint security group ingress rules
# Restricts access to only private subnets within the workload VPC
locals {
  allowed_vpce_ingress_cidrs = aws_subnet.private[*].cidr_block
}

##################################
# Security Group for VPC Endpoints
##################################

# Security group for VPC endpoints in workload VPC
resource "aws_security_group" "vpce_sg" {
  name        = "workload-vpce-sg"
  description = "Security group for VPC endpoints in workload VPC"
  vpc_id      = aws_vpc.workload.id

  # Allow inbound HTTPS traffic from allowed CIDR blocks
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.allowed_vpce_ingress_cidrs
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "workload-vpce-sg"
    Tier = "endpoint"
  }
}

#############################
# SSM Interface VPC Endpoint
#############################

# Enable private access to AWS Systems Manager from the workload VPC
resource "aws_vpc_endpoint" "ssm" {
  # Create endpoint inside workload VPC
  vpc_id            = aws_vpc.workload.id
  vpc_endpoint_type = "Interface"

  # AWS SSM endpoint service endpoint
  service_name = "com.amazonaws.us-east-1.ssm"

  # Resolve SSM DNS names to private IPs in the VPC
  private_dns_enabled = true

  # Place endpoint network interfaces in private subnets
  subnet_ids = aws_subnet.private[*].id

  # Restrict endpoint access to traffic originating from private subnets only
  security_group_ids = [aws_security_group.vpce_sg.id]

  tags = {
    Name = "workload-vpce-ssm"
    Tier = "endpoint"
  }
}

#############################
# SSM Messages VPC Endpoint
#############################

# Enable private access to AWS Systems Manager Messages from the workload VPC
resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id              = aws_vpc.workload.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.us-east-1.ssmmessages"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpce_sg.id]

  tags = {
    Name = "workload-vpce-ssm-messages"
    Tier = "endpoint"
  }
}

#############################
# EC2 Messages VPC Endpoint
#############################

# Enable private access to AWS EC2 Messages from the workload VPC
resource "aws_vpc_endpoint" "ec2_messages" {
  vpc_id              = aws_vpc.workload.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.us-east-1.ec2messages"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.vpce_sg.id]

  tags = {
    Name = "workload-vpce-ec2-messages"
    Tier = "endpoint"
  }
}

#############################
# S3 Gateway VPC Endpoint
#############################

# Enable private access to AWS S3 from the workload VPC
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.workload.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.us-east-1.s3"
  route_table_ids   = [aws_route_table.private.id]

  tags = {
    Name = "workload-vpce-s3"
    Tier = "endpoint"
  }
}