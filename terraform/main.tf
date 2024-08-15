module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

module "subnet" {
  source     = "./modules/subnet"
  vpc_id     = module.vpc.id
  cidr_block = "10.0.1.0/24"
}

 module "security_group" {
   source = "./modules/security_group"
   vpc_id = module.vpc.id
 }

 module "ec2" {
   source             = "./modules/ec2"
   ami                = "ami-04a81a99f5ec58529" 
   instance_type      = "t2.micro"
   key_name           = "Mykeypair"
   subnet_id          = module.subnet.id
   security_group_ids = [module.security_group.id]
 }