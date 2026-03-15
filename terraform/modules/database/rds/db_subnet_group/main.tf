resource "aws_db_subnet_group" "backend_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.db_subnet_group

  tags = {
    Name = var.db_subnet_group_name
  }
}