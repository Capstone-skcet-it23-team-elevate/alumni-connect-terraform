resource "aws_instance" "backend-server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "backend-server"
  }
}
