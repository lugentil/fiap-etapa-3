variable "node_role_arn" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "node_group_name" {
  type = string
}

variable "node_group_version" {
  type = string
}

variable "subnet_ids" {
  type = list(string) 
}

variable "capacity_type" {
  type = string
}

variable "instance_types" {
  type = list(string)
}