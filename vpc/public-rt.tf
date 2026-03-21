resource "aws_route_table" "alumni-public-rt" {
  vpc_id = aws_vpc.alumni-connect-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.alumni-igw.id
  }

  tags = {
    Name = "alumni-public-rt"
  }
}

output "public-rt-id" {
  value = aws_route_table.alumni-public-rt.id
}
