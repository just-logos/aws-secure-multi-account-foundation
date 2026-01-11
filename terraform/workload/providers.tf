provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
        Project = "aws-secure-multi-account-foundation"
        Environment = "lab"
        Owner = "KevinZheng"
    }
  }
}