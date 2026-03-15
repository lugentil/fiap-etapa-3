resource "aws_eks_cluster" "eks_cluster_tech_challenge" {
  name = var.cluster_name

  access_config {
    authentication_mode = "API"
  }

  role_arn = var.cluster_role_arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = [
      var.subnet_id_a,
      var.subnet_id_b
    ]
  }
}
