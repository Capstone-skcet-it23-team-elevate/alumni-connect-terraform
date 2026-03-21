resource "aws_internet_gateway" "alumni-igw" {
  vpc_id = aws_vpc.alumni-connect-vpc.id
}
