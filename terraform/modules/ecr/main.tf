resource "aws_ecr_repository" "ecr_repository" {
  for_each             = toset(var.ecr_repository_name)
  name                 = each.value
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = false
  }
}