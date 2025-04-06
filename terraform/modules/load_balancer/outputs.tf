output "alb_target_group_arn" {
  value = aws_lb_target_group.my_target_grp.arn
}

output "alb_dns" {
  value = aws_lb.my_alb.dns_name
}