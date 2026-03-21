variable "redis_name" {
    type = string
}

variable "subnet_ids" {
    type = list(string)
}

variable "major_engine_version" {
    type = string
}
