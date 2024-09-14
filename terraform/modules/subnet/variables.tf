variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "public_subnet" {
  description = "True if this subnet should be public, otherwise false"
  type        = bool
}
