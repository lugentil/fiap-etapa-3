aws_region             = "us-east-1"
project_name           = "togglemaster"
environment            = "production"
vpc_cidr               = "10.0.0.0/16"
eks_node_instance_type = "t3.medium"
eks_node_desired       = 2
eks_node_min           = 1
eks_node_max           = 3
rds_instance_class     = "db.t3.micro"
elasticache_node_type  = "cache.t3.micro"

db_passwords = {
  auth_db      = "Teste123Auth"
  flags_db     = "Teste123Flags"
  targeting_db = "Teste123Targeting"
}

master_key      = "togglemaster-secret-key"
service_api_key = "togglemaster-api-key"
gitops_repo_url = "https://github.com/fsampaio21/fiap-etapa-3.git"

aws_credentials = {
  access_key    = ""
  secret_key    = ""
  session_token = ""
}
