##############################
# AWS Provider Configuration
##############################

# Configure the AWS provider for workload account
# Tells Terraform which region to operate in and how resources should be tagged by default
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "aws-secure-multi-account-foundation"
      Environment = "lab"
      Owner       = "KevinZheng"
    }
  }
}