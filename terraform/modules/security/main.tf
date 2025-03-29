resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = {
    Name = "App alb_sg"
  }
}

resource "aws_security_group" "eb_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Elastic Beanstalk Security Group"
  }
}

resource "aws_iam_role" "beanstalk_role" {
  name = "beanstalk-ec2-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = ["ec2.amazonaws.com", "elasticbeanstalk.amazonaws.com"]
        }
      }
    ]
  })
}

resource "aws_iam_policy" "beanstalk_s3_dynamodb_access" {
  name        = "beanstalk-s3-dynamodb-policy"
  description = "Allow Beanstalk to access S3 and DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
          var.s3_bucket_arn,
          "${var.s3_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = var.dynamodb_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_beanstalk_policy" {
  role       = aws_iam_role.beanstalk_role.name  
  policy_arn = aws_iam_policy.beanstalk_s3_dynamodb_access.arn
}

resource "aws_iam_instance_profile" "beanstalk_iam_profile" {
  name = "beanstalk-instance-profile"
  role = aws_iam_role.beanstalk_role.name
}