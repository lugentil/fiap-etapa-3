variable "allocated_storage" {
  type = number
}

variable "identifier" {
  type = string
}

variable "db_name" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
  sensitive = true
}

variable "storage_type" {
  type = string
}

variable "db_subnet_group_name" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}