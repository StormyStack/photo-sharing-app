resource "aws_lb" "my_alb" {
  name                        = var.alb_name
  internal                    = false
  load_balancer_type          = "application"
  subnets                     = var.public_subnet_ids
  security_groups             = [var.alb_sg_id]
  enable_deletion_protection  = false
  enable_cross_zone_load_balancing = true
  tags = {
    Name = "My Photo Sharing ALB"
  }
}

resource "aws_lb_target_group" "photo_app_target_group" {
  name     = "photo-sharing-app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.photo_app_target_group.arn
  }
}