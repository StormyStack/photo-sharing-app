output "eb_sg_id" {
  value = aws_security_group.eb_sg.id
}

output "beanstalk_iam_profile_name" {
  value = aws_iam_instance_profile.beanstalk_iam_profile.name
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}