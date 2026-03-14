 resource "aws_vpc" "tech_challenge" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.tag_name
  }
}