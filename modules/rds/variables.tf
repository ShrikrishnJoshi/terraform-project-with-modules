variable "db_name" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "allocated_storage" {}
variable "username" {}
variable "password" {}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}