
module "sg" {
  source = "../../modules/sg"

  env    = var.env
  vpc_id = var.vpc_id

  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules
}

module "ec2" {
    source = "../../modules/ec2"
    ami = var.ami
    instance_type = var.instance_type
    env = var.env 
    sg_id = module.sg.sg_id
    key_name = var.key_name
    user_data = file("${path.module}/../../scripts/userdata.sh")
}

