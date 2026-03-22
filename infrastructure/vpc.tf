resource "aws_vpc" "alumni-connect-vpc" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "alumni-connect-vpc"
  }
}

resource "aws_internet_gateway" "alumni-igw" {
  vpc_id = aws_vpc.alumni-connect-vpc.id

  tags = {
    Name = "alumni-igw"
  }
}

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

resource "aws_route_table" "private-nat-rt" {
  vpc_id = aws_vpc.alumni-connect-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.alumni-nat-gw.id
  }

  tags = {
    Name = "private-nat-rt"
  }
}
