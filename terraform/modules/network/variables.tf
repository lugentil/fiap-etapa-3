variable "vpc_tag_name" {
    type    = string
}

variable "vpc_cidr_block" {
  type =  string
}

################ Variaveis para Subnet Priv A ################
variable "subnet_config" {
  type    = map(any)
}

variable "igw_tag_name" {
  type = string
}

variable "ngw_tag_name" {
  type = string
}