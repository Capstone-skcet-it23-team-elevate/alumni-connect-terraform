resource "aws_iam_user" "alumni-deployer" {
  name = "alumni-deployer"
}

resource "aws_iam_access_key" "alumni-deployer-key" {
  user = aws_iam_user.alumni-deployer.name
}

