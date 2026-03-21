resource "aws_instance" "database-server" {
  ami = data.aws_ami.ubuntu
  instance_type = "t2.micro"

  tags = {
    Name = "database-server"
  }
}
