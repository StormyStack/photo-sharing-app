resource "aws_launch_template" "photo-server_launch-template" {
  name_prefix = "photo-web-server-template-"
  image_id    = var.ami_id
  instance_type = var.instance_type
  user_data   = base64encode(file("script.sh"))
  iam_instance_profile {
    name = var.ec2_iam_profile_name
  }
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [var.ec2_sg_id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Photo-server_template"
    }
  }
}

resource "aws_autoscaling_group" "photoapp_asg" {
  desired_capacity = 2
  max_size = 4
  min_size = 2
  vpc_zone_identifier = var.subnet_ids
  
  launch_template {
    id = aws_launch_template.photo-server_launch-template.id
    version = "$Latest"
  }

  target_group_arns = [var.alb_target_group_arn]

  tag {
    key = "Name"
    value = "photo_Server-Instance"
    propagate_at_launch = true
  }
}