resource "aws_vpc" "alumni-connect-vpc" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "alumni-connect-vpc"
  }
}
