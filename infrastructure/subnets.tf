resource "aws_subnet" "management-subnet" {
  vpc_id                  = aws_vpc.alumni-connect-vpc.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "management-subnet"
  }
}

resource "aws_subnet" "backend-subnet" {
  vpc_id            = aws_vpc.alumni-connect-vpc.id
  cidr_block        = "172.16.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "backend-subnet"
  }
}

resource "aws_subnet" "database-subnet" {
  vpc_id            = aws_vpc.alumni-connect-vpc.id
  cidr_block        = "172.16.3.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "database-subnet"
  }
}

# for alb
resource "aws_subnet" "empty-subnet" {
  vpc_id            = aws_vpc.alumni-connect-vpc.id
  cidr_block        = "172.16.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "empty-subnet"
  }
}

resource "aws_route_table_association" "management-subnet" {
  subnet_id      = aws_subnet.management-subnet.id
  route_table_id = aws_route_table.alumni-public-rt.id
}

resource "aws_route_table_association" "database-subnet" {
  subnet_id      = aws_subnet.database-subnet.id
  route_table_id = aws_route_table.private-nat-rt.id
}

resource "aws_route_table_association" "backend-subnet" {
  subnet_id      = aws_subnet.backend-subnet.id
  route_table_id = aws_route_table.private-nat-rt.id
}

resource "aws_route_table_association" "empty-subnet" {
  subnet_id      = aws_subnet.empty-subnet.id
  route_table_id = aws_route_table.alumni-public-rt.id
}
