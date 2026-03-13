variable "ami" {
    description = "AMI ID"
}
variable "instance_type" {
    description = "EC2 type"
}
variable "env" {
    description = "Envirnment name"
}

variable "sg_id" {
    description = "Security Group Id"
  
}
variable "key_name" {
    description = "Ec2 key pair name"
  
}

variable "user_data" {
  description = "User data script"
  type        = string
}

variable "subnet_id" {
}