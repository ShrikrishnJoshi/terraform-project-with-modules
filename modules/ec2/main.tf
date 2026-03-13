
resource "aws_instance" "this" {
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = [ var.sg_id ]
    key_name = var.key_name
    user_data = var.user_data
    subnet_id = var.subnet_id
    tags = {
      Name = "${var.env}-ec2"
    }  
}



