resource "aws_route_table" "tech_challenge" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gtw_id
  }

  tags = {
    Name = var.tag_name
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = var.subnet_id_a
  route_table_id = aws_route_table.tech_challenge.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = var.subnet_id_b
  route_table_id = aws_route_table.tech_challenge.id
}