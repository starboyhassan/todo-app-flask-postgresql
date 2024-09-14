resource "aws_subnet" "MySubnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  map_public_ip_on_launch = var.public_subnet  
  
  tags = {
    Name = "MySubnet"
  }
}

