############################
# Terraform Versioning
############################

# Define Terraform version and required providers
terraform {
  # Reqire Terraform version 1.0 or higher
  required_version = ">= 1.0"

  # Define required providers
  required_providers {
    aws = {
      # Use the HashiCorp AWS provider
      source = "hashicorp/aws"
      # Allow any 5.x version of the AWS provider
      version = "~> 5.0"
    }
  }
}