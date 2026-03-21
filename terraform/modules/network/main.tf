 resource "aws_vpc" "tech_challenge" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_tag_name
  }
}

resource "aws_subnet" "tech_challenge" {
  for_each   = var.subnet_config
  vpc_id     = aws_vpc.tech_challenge.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = each.key
  }
depends_on = [ aws_vpc.tech_challenge ]
}

resource "aws_internet_gateway" "tech_challenge" {
  vpc_id = aws_vpc.tech_challenge.id

  tags = {
    Name = var.igw_tag_name
  }
 depends_on = [ aws_internet_gateway.tech_challenge ]
}

resource "aws_eip" "eip_nat_tech_challenge" {
  domain = "vpc"
  depends_on = [ aws_subnet.tech_challenge ]
}

resource "aws_nat_gateway" "tech_challenge" {
  for_each = { for k, v in var.subnet_config : k => v if v.nat_subnet }

  allocation_id = aws_eip.eip_nat_tech_challenge.id
  subnet_id     = aws_subnet.tech_challenge[each.key].id

  tags = {
    Name = var.ngw_tag_name
  }
depends_on = [aws_eip.eip_nat_tech_challenge]
}

resource "aws_route_table" "private_tech_challenge" {
  count  = anytrue([for i in var.subnet_config : i.nat_subnet]) ? 0 : 1
  vpc_id = aws_vpc.tech_challenge.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.tech_challenge[0].id
  }

  tags = {
    Name = "route-table-priv"
  }
}

resource "aws_route_table" "public_tech_challenge" {
  count  = anytrue([for i in var.subnet_config : i.nat_subnet]) ? 1 : 0
  vpc_id = aws_vpc.tech_challenge.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tech_challenge.id
  }

  tags = {
    Name = "route-table-pub"
  }
}

resource "aws_route_table_association" "private" {
  for_each = { for k, v in var.subnet_config : k => v if v.nat_subnet }

  subnet_id      = aws_subnet.tech_challenge[each.key].id
  route_table_id = one(aws_route_table.private_tech_challenge[*].id)
depends_on = [ aws_route_table.private_tech_challenge ]
}

resource "aws_route_table_association" "public" {
  for_each = { for k, v in var.subnet_config : k => v if !v.nat_subnet }

  subnet_id      = aws_subnet.tech_challenge[each.key].id
  route_table_id = aws_route_table.public_tech_challenge[0].id

 depends_on = [ aws_route_table.public_tech_challenge ]
}