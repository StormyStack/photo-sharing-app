resource "aws_lb" "my_alb" {
  name = var.alb_name
  internal = false
  load_balancer_type = "application"
  subnets = var.public_subnet_cidr
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
  tags = {
    Name = "My Photo Sharing ALB"
  }
}

resource "aws_lb_target_group" "my_target_grp" {
  name = "my_target_grp"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    interval = 30
    path = "/health"
    protocol = "HTTP"
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "My ALB Target Group"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.my_target_grp.arn
  }
}