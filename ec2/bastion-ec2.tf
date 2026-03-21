resource "aws_instance" "bastion" {
  ami = data.aws_ami.ubuntu
  instance_type = "t2.micro"

  tags = {
    Name = "bastion"
  }
}
