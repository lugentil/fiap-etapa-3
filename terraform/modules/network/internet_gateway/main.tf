resource "aws_internet_gateway" "tech_challenge" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.tag_name
  }
}