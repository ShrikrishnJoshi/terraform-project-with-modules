variable "ami" {}
variable "instance_type" {}
variable "env" {}

variable "vpc_id" {}

variable "ingress_rules" {
  type = any
}

variable "egress_rules" {
  type = any
}

variable "key_name" {
  description = "EC2 key pair name"
  
}