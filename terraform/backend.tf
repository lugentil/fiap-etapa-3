terraform {
  backend "s3" {
    bucket          = "tech-challenge-oficial"
    key             = "infrastructure/terraform.tfstate"
    region          = "us-east-1"
    dynamodb_table  = "terraform-locks"
    encrypt         = true
  }
}