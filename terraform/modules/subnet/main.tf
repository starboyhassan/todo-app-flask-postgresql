resource "aws_subnet" "MySubnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  tags = {
    Name = "MySubnet"
  }
}
