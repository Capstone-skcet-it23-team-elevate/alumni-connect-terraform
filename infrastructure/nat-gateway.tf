resource "aws_eip" "nat-gateway-elastic-ip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "alumni-nat-gw" {
  allocation_id = aws_eip.nat-gateway-elastic-ip.id
  subnet_id = aws_subnet.management-subnet.id

  tags = {
    Name = "alumni-nat-gw"
  }
}
