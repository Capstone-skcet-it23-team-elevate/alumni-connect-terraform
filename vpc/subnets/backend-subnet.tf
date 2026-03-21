module "vpc-stuff" {
  source = "../"
}

resource "aws_subnet" "management-subnet" {
  vpc_id     = module.vpc-stuff.alumni-vpc-id
  cidr_block = "172.16.2.0/24"
  tags = {
    Name = "management-subnet"
  }
}

# resource "aws_route_table_association" "management-subnet" {
#     subnet_id = aws_subnet.management-subnet.id
#     route_table_id = module.vpc-stuff.public-rt-id
# }
