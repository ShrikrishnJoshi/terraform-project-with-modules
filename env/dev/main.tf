module "vpc" {
  source = "../../modules/vpc"

  env                 = var.env
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  az                  = var.az
}

module "sg" {
  source = "../../modules/sg"
  env    = var.env
  vpc_id = module.vpc.vpc_id

  ingress_rules = var.ingress_rules
  egress_rules  = var.egress_rules
}

module "ec2" {
  source = "../../modules/ec2"

  ami           = var.ami
  instance_type = var.instance_type
  env           = var.env

  sg_id     = module.sg.sg_id
  subnet_id = module.vpc.public_subnet_id

  key_name  = var.key_name
  user_data = file("${path.root}/../../scripts/userdata.sh")
}

module "rds" {
  source = "../../modules/rds"

  db_name           = "devdb"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username = "admin"
  password = "Admin@123"

  subnet_ids = [
    "subnet-xxxx",
    "subnet-yyyy"
  ]

  security_group_ids = ["sg-xxxx"]
}

module "rds" {
  source = "../../modules/rds"

  db_name           = "devdb"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  username = "admin"
  password = "Admin@123"

  subnet_ids         = ["subnet-xxxx","subnet-yyyy"]
  security_group_ids = ["sg-xxxx"]
}