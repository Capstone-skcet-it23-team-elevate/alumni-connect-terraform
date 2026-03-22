resource "aws_security_group" "bastion-sg" {
  name = "bastion-security-group"
  vpc_id = aws_vpc.alumni-connect-vpc.id
  description = "Allow SSH and ping from internet"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb-sg" {
  name = "Application Load Balancer Security Group"
  vpc_id = aws_vpc.alumni-connect-vpc.id
  description = "Allow 80 from internet and egress to backend-sg"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    security_groups = [ aws_security_group.backend-sg.id ]
  }
}

resource "aws_security_group" "backend-sg" {
  name = "backend-security-group"
  vpc_id = aws_vpc.alumni-connect-vpc.id
  description = "Allow ping and SSH from bastion-sg"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [ aws_security_group.bastion-sg.id ]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    security_groups = [ aws_security_group.bastion-sg.id ]
  }

  ingress {
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    security_groups = [ aws_security_group.alb-sg.id ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db-sg" {
  name = "db-security-group"
  vpc_id = aws_vpc.alumni-connect-vpc.id
  description = "Allow SSH and ping from bastion-sg, and 5432 from backend-sg"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [ aws_security_group.bastion-sg.id ]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    security_groups = [ aws_security_group.bastion-sg.id ]
  }

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [ aws_security_group.backend-sg.id ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_security_group" "nat-instance-sg" {
  name = "nat-instance-security-group"
  vpc_id = aws_vpc.alumni-connect-vpc.id
  description = "Allow SSH and ping bastion, and NATting"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ aws_vpc.alumni-connect-vpc.cidr_block ]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [ aws_security_group.bastion-sg.id ]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    security_groups = [ aws_security_group.bastion-sg.id ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
