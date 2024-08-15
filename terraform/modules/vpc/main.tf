resource "aws_vpc" "MyVPC" {
  cidr_block = var.cidr_block
  tags = {
    Name = "MyVPC"
  }
}

output "id" {
  value = aws_vpc.MyVPC.id
}