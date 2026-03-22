resource "aws_alb" "alumni-alb-backend" {
  name               = "alumni-alb-backend"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.management-subnet.id, aws_subnet.empty-subnet.id]

  tags = {
    Name = "alumni-application-load-balancer-for-backend"
  }
}

resource "aws_lb_listener" "alumni-alb-listener" {
  load_balancer_arn = aws_alb.alumni-alb-backend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alumni-alb-backend-target-group.arn
  }
}

resource "aws_lb_target_group" "alumni-alb-backend-target-group" {
  name     = "alumni-alb-backend-target-group"
  port     = 8000
  vpc_id   = aws_vpc.alumni-connect-vpc.id
  protocol = "HTTP"
}

resource "aws_lb_target_group_attachment" "attach-alumni-alb-to-backend-ec2" {
  target_id        = aws_instance.backend-server.id
  target_group_arn = aws_lb_target_group.alumni-alb-backend-target-group.arn
  port             = 8000
}
