resource "aws_subnet" "tech_challenge" {
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name = var.tag_name
  }
}