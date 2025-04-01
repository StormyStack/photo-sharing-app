resource "aws_key_pair" "ssh-key" {
  key_name   = "photoapp-key-pair"
  public_key = file(var.public_key_location)
}

resource "aws_instance" "photo_web_server" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.ssh-key.key_name
  subnet_id = var.subnet_ids[0]
  security_groups = [var.ec2_sg_id]
  iam_instance_profile = var.ec2_iam_profile_name
  associate_public_ip_address = true
  user_data = file("script.sh")
  tags = {
    Name = "Photo Sharing App Instance"
  }
}

resource "aws_ami_from_instance" "photoapp_ami" {
  name = "Photo_app_ami"
  source_instance_id = aws_instance.photo_web_server.id
}

resource "aws_launch_template" "asg_template" {
  name = "photo_app_launch_template"
  image_id = aws_ami_from_instance.photoapp_ami.id
  instance_type = var.instance_type
  
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
      Name = "ASG_instance"
    }
  }
}

resource "aws_autoscaling_group" "photoapp_asg" {
  desired_capacity = 2
  max_size = 4
  min_size = 2
  vpc_zone_identifier = var.subnet_ids
  
  launch_template {
    id = aws_launch_template.asg_template.id
    version = "$Latest"
  }

  target_group_arns = [var.alb_target_group_arn]

  tag {
    key = "Name"
    value = "ASG-Instance"
    propagate_at_launch = true
  }
}