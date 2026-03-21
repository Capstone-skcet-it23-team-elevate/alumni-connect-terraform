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

  database-run = <<-EOF
    mkdir /postgres_data
    docker run -d \
        --name postgres \
        --restart unless-stopped \
        -e POSTGRES_USER=postgres \
        -e POSTGRES_PASSWORD=${var.db_password} \
        -e POSTGRES_DB=alumni_connect \
        -v /postgres_data:/var/lib/postgresql/data \
        -p 0.0.0.0:5432:5432 \
        postgres:16
    EOF

  backend-run = <<-EOF
    docker run -d \
        --name alumni-connect-backend \
        --restart unless-stopped \
        -e DATABASE_URL=postgresql://postgres:${var.db_password}@${aws_instance.database-server.private_ip}/alumni_connect \
        -p 0.0.0.0:8000:8000 \
        shobanchiddarth/alumni-connect-backend:0.0.2
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
  user_data = local.base-init

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
  user_data = join("\n", [local.base-init, local.nat-setup])

  tags = {
    Name = "nat-instance"
  }
}

resource "aws_instance" "database-server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.database-subnet.id
  user_data = join("\n", [local.base-init, local.docker-install, local.database-run])

  tags = {
    Name = "database-server"
  }
}

resource "aws_instance" "backend-server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.backend-subnet.id
  user_data = join("\n", [local.base-init, local.docker-install, local.backend-run])

  tags = {
    Name = "backend-server"
  }
}

