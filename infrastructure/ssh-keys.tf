resource "tls_private_key" "alumni-management-pair" {
  algorithm = "ED25519"
}

resource "tls_private_key" "alumni-bastion-pair" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "alumni-management-pub" {
  key_name   = "alumni-management"
  public_key = tls_private_key.alumni-management-pair.public_key_openssh
}

resource "aws_key_pair" "alumni-bastion-pub" {
  key_name   = "alumni-bastion"
  public_key = tls_private_key.alumni-bastion-pair.public_key_openssh
}

resource "local_file" "alumni-bastion-private-key" {
  filename        = "${path.module}/.ssh/alumni-bastion.pem"
  content         = tls_private_key.alumni-bastion-pair.private_key_openssh
  file_permission = "0600"
}
