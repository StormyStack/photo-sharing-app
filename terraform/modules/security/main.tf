resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic from anywhere"
  }
  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description      = "Allow HTTP(S) traffic to EC2 instances"
  }
  tags = {
    Name = "App alb_sg"
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description      = "Allow HTTP traffic from the ALB"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my-ip]
    description = "Allow SSH access from my IP"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic (can be made more specific if needed)"
  }
  tags = {
    Name = "App ec2_sg"
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-aws-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_role.name  
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "attach_db_policy" {
  role       = aws_iam_role.ec2_role.name  
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_instance_profile" "ec2_iam_profile" {
  name = "ec2_access_profile"
  role = aws_iam_role.ec2_role.name
}