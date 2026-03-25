output "cluster_endpoint" {
  description = "URL do endpoint do cluster EKS"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = aws_eks_cluster.main.name
}

output "cluster_ca_certificate" {
  description = "Certificado CA do cluster (base64)"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "ID do security group do cluster, usado nas regras de ingress dos bancos"
  value       = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
}
