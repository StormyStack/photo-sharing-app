output "alb-sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ec2-ag_id" {
  value = aws_security_group.ec2_sg.id
}

output "ec2_iam_profile_name" {
  value = aws_iam_instance_profile.ec2_iam_profile.name
}