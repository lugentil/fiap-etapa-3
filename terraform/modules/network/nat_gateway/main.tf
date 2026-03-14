resource "aws_eip" "eip_nat_tech_challenge" {
  domain = "vpc"
}

resource "aws_nat_gateway" "tech_challenge" {
  allocation_id = aws_eip.eip_nat_tech_challenge.id
  subnet_id     = var.aws_subnet_id

  tags = {
    Name = var.tag_name
  }
depends_on = [aws_eip.eip_nat_tech_challenge]
}