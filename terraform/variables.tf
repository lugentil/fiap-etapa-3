################ Variaveis para VPC ################
variable "tag_name" {
  type    = string
  default = "vpc-tech-challenge"
}

variable "vpc_cidr_block" {
  type    =  string
  default = "10.0.0.0/16"
}
################ Variaveis para Subnet Priv A ################
variable "subnet_priv_a_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}

variable "subnet_priv_a_tag_name" {
  type    = string
  default = "subnet-priv-a-tech-challenge"
}

variable "subnet_priv_a_availability_zone" {
  type    = string
  default = "us-east-1a"
}
################ Variaveis para Subnet Priv B ################
variable "subnet_priv_b_cidr_block" {
  type    = string
  default = "10.0.3.0/24"
}

variable "subnet_priv_b_tag_name" {
  type    = string
  default = "subnet-priv-b-tech-challenge"
}

variable "subnet_priv_b_availability_zone" {
  type    = string
  default = "us-east-1b"
}

################ Variaveis para Subnet Pub A ################
variable "subnet_pub_a_cidr_block" {
  type    = string
  default = "10.0.2.0/24"
}

variable "subnet_pub_a_tag_name" {
  type    = string
  default = "subnet-pub-a-tech-challenge"
}

variable "subnet_pub_a_availability_zone" {
  type    = string
  default = "us-east-1a"
}

################ Variaveis para Subnet Pub B ################
variable "subnet_pub_b_cidr_block" {
  type    = string
  default = "10.0.4.0/24"
}

variable "subnet_pub_b_tag_name" {
  type    = string
  default = "subnet-pub-b-tech-challenge"
}

variable "subnet_pub_b_availability_zone" {
  type    = string
  default = "us-east-1b"
}

################ Variaveis para IGW ################
variable "igw_tag_name" {
  type    = string
  default = "igw-tech-challenge"
}

################ Variaveis para NGW ################
variable "ngw_tag_name"{
  type = string
  default = "ngw-tech-challenge"
}

################ Variaveis para Route Table ################
variable "route_table_tag_name" {
  type = string
  default = "rt-table-tech-challenge"
}

################ Variaveis para EKS ################
variable "cluster_role_arn" {
  type = string
  default = "arn:aws:iam::730335515098:role/LabRole"
}

variable "cluster_name" {
  type = string
  default = "eks-cluster-tech-challenge"
}

variable "cluster_version" {
  type = string
  default = "1.35"
}
################ Variaveis para NP ################
variable "node_role_arn" {
  type = string
  default = "arn:aws:iam::730335515098:role/LabRole"
}

variable "node_group_name" {
  type = string
  default = "np-tech-challenge"
  description = "Pool de nós do cluster"
}

variable "node_group_version" {
  type = string
  default = "1.35"
  description = "Pool de nós do cluster"
}

variable "node_group_capacity_type" {
  type = string
  default = "ON_DEMAND"
}

variable "node_group_instance_types" {
  type = list(string)
  default = [ "t3.medium" ]
}

################ Variaveis para Subnet Group ################
variable "db_subnet_group_name" {
  type = string
  default = "db-subnet-group-tech-challenge"
}
################ Variaveis para o Postgresql auth-service ################
variable "auth_service_allocated_storage" {
  type = number
  default = 20
}

variable "auth_service_identifier" {
  type = string
  default = "auth-service"
  description = "Nome do identificado na AWS"
}
variable "auth_service_db_name" {
  type = string
  default = "authservice"
  description = "Nome do database"
}

variable "auth_service_engine" {
  type = string
  default = "postgres"
  description = "Engine de banco utilizada. Ex: postgres/mysql"
}

variable "auth_service_engine_version" {
  type = string
  default = "17.6"
  description = "Versão do Postgres utilizado."
}

variable "auth_service_instance_class" {
  type = string
  default = "db.t4g.micro"
  description = "Classe de instância utilizada para o banco de dados."
}

variable "auth_service_username" {
  type = string
  default = "authservice"
  description = "Usuário para autenticação no banco de dados."
}

variable "auth_service_password" {
  type = string
  sensitive = true
  description = "Senha para conexão no banco de dados."
}

variable "auth_service_storage_type" {
  type = string
  default = "gp2"
  description = "Tipo de storage para o banco de dados."
}

variable "auth_service_db_vpc_security_group_ids" {
  type = list(string)
  default = [""]
  description = "Security Groups para o banco de dados."
}

variable "auth_service_availability_zone" {
  type = string
  default = "us-east-1a"
  description = "Zona de disponibilidade para o banco de dados."
}

 ################ Variaveis para o Postgresql flag-service ################
variable "flag_service_allocated_storage" {
  type = number
  default = 20
}

variable "flag_service_identifier" {
  type = string
  default = "flag-service"
  description = "Nome do identificado na AWS"
}
variable "flag_service_db_name" {
  type = string
  default = "flagservice"
  description = "Nome do database"
}

variable "flag_service_engine" {
  type = string
  default = "postgres"
  description = "Engine de banco utilizada. Ex: postgres/mysql"
}

variable "flag_service_engine_version" {
  type = string
  default = "17.6"
  description = "Versão do Postgres utilizado."
}

variable "flag_service_instance_class" {
  type = string
  default = "db.t4g.micro"
  description = "Classe de instância utilizada para o banco de dados."
}

variable "flag_service_username" {
  type = string
  default = "flagservice"
  description = "Usuário para autenticação no banco de dados."
}

variable "flag_service_password" {
  type = string
  sensitive = true
  description = "Senha para conexão no banco de dados."
}

variable "flag_service_storage_type" {
  type = string
  default = "gp2"
  description = "Tipo de storage para o banco de dados."
}

variable "flag_service_db_vpc_security_group_ids" {
  type = list(string)
  default = [""]
  description = "Security Groups para o banco de dados."
}

variable "flag_service_availability_zone" {
  type = string
  default = "us-east-1a"
  description = "Zona de disponibilidade para o banco de dados."
}

 ################ Variaveis para o Postgresql targeting-service ################
variable "targeting_service_allocated_storage" {
  type = number
  default = 20
}

variable "targeting_service_identifier" {
  type = string
  default = "targeting-service"
  description = "Nome do identificado na AWS"
}
variable "targeting_service_db_name" {
  type = string
  default = "targetingservice"
  description = "Nome do database"
}

variable "targeting_service_engine" {
  type = string
  default = "postgres"
  description = "Engine de banco utilizada. Ex: postgres/mysql"
}

variable "targeting_service_engine_version" {
  type = string
  default = "17.6"
  description = "Versão do Postgres utilizado."
}

variable "targeting_service_instance_class" {
  type = string
  default = "db.t4g.micro"
  description = "Classe de instância utilizada para o banco de dados."
}

variable "targeting_service_username" {
  type = string
  default = "flagservice"
  description = "Usuário para autenticação no banco de dados."
}

variable "targeting_service_password" {
  type = string
  sensitive = true
  description = "Senha para conexão no banco de dados."
}

variable "targeting_service_storage_type" {
  type = string
  default = "gp2"
  description = "Tipo de storage para o banco de dados."
}

variable "targeting_service_db_vpc_security_group_ids" {
  type = list(string)
  default = [""]
  description = "Security Groups para o banco de dados."
}

variable "targeting_service_availability_zone" {
  type = string
  default = "us-east-1a"
  description = "Zona de disponibilidade para o banco de dados."
}