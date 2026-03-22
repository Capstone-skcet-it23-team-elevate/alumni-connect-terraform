output "alb_dns" {
  value = aws_alb.alumni-alb-backend.dns_name
}
