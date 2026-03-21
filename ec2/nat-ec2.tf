resource "aws_instance" "nat-instance" {
  ami = data.aws_ami.ubuntu
  instance_type = "t2.micro"

  tags = {
    Name = "nat-instance"
  }
}
