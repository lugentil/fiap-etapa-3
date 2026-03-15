resource "aws_db_instance" "postgresql" {
  allocated_storage       = 10
  identifier              = var.identifier
  db_name                 = var.db_name
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  username                = var.username
  password                = var.password
  skip_final_snapshot     = true
  availability_zone       = var.availability_zone
  storage_type            = var.storage_type 
  db_subnet_group_name    = var.db_subnet_group_name
  vpc_security_group_ids  = var.vpc_security_group_ids
}
