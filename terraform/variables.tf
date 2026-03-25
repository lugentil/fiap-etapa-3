variable "aws_region" {
  description = "Regiao da AWS"
  default     = "us-east-1"
}

variable "aws_availability_zones" {
  description = "Lista de AZs"
  type        = list(string)
  default     = [ "us-east-1a", "us-east-1b" ]
}

variable "project_name" {
  description = "Nome do projeto para os recursos"
  default     = "togglemaster"
}

variable "environment" {
  description = "Ambiente"
  default     = "production"
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC"
  default     = "10.0.0.0/16"
}

variable "eks_node_instance_type" {
  description = "Instancia EC2 para NP"
  default     = "t3.medium"
}

variable "eks_node_desired" {
  description = "Quantidade nodes para o NP"
  default     = 2
}

variable "eks_node_min" {
  description = "Quantidade minima de nodes para o NP"
  default     = 1
}

variable "eks_node_max" {
  description = "Quantidade maxima de nodes para o NP"
  default     = 3
}

variable "rds_instance_class" {
  description = "Shape para os bancos PostgreSQL"
  default     = "db.t3.micro"
}

variable "elasticache_node_type" {
  description = "Tipo de node do ElastiCache Redis"
  default     = "cache.t3.micro"
}

variable "db_passwords" {
  description = "Senhas dos bancos de dados"
  type        = map(string)
  sensitive   = true
}

variable "ecr_repositories" {
  description = "Lista de repositorios ECR"
  default = [
    "auth-service",
    "flag-service",
    "targeting-service",
    "evaluation-service",
    "analytics-service"
  ]
}

variable "master_key" {
  description = "Chave do auth-service para criacao de API keys"
  type        = string
  sensitive   = true
  default     = "togglemaster-secret-key"
}

variable "service_api_key" {
  description = "Service API para o evaluation-service"
  type        = string
  sensitive   = true
  default     = "togglemaster-api-key"
}

variable "gitops_repo_url" {
  description = "URL do repositorio Git que o ArgoCD monitora para sincronizar os deploys"
  type        = string
  default     = "https://github.com/fsampaio21/fiap-etapa-3.git"
}

variable "aws_credentials" {
  description = "Credenciais AWS para recursos Kubernetes"
  type = object({
    access_key    = string
    secret_key    = string
    session_token = string
  })
  sensitive = true
  default = {
    access_key    = ""
    secret_key    = ""
    session_token = ""
  }
}
