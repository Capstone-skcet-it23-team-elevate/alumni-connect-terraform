locals {
  base-init = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get upgrade -y
    apt-get install -y curl
  EOF

  docker-install = <<-EOF
    curl https://get.docker.com | bash
  EOF

  nat-setup = <<-EOF
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p
    apt-get install -y iptables-persistent
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    netfilter-persistent save
  EOF
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.management-subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "bastion"
  }
}

resource "aws_instance" "nat-instance" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.public-nat-subnet.id
  associate_public_ip_address = true
  source_dest_check = false

  tags = {
    Name = "nat-instance"
  }
}

resource "aws_instance" "backend-server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.backend-subnet.id

  tags = {
    Name = "backend-server"
  }
}

resource "aws_instance" "database-server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.database-subnet.id

  tags = {
    Name = "database-server"
  }
}
