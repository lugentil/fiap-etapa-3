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