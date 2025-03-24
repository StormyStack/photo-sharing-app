resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tpc"
    security_groups = [aws_security_group.ec2_sg.id]
  }
  tags = {
    Name = "App alb_sg"
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.alb_sg]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my-ip]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tpc"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "App ec2_sg"
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-aws_iam_role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Principal": {
                "Service": [
                    "ec2.amazonaws.com"
                ]
            }
        }
    ]
})
}

resource "aws_iam_policy" "s3-dynamodb-access" {
  name = "s3 dynamodb access policy"
  description = "EC2 can access S3 and DynamoDB."
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ]
            "Resource": [
              var.s3_bucket_arn,
              "${var.s3_bucket_arn}/*"
            ]
        }
    ]
},{
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ]
        Resource = var.dynamodb_arn
      } )
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role = aws_iam_role.ec2_role
  policy_arn = aws_iam_policy.s3-dynamodb-access.arn
}

resource "aws_iam_instance_profile" "ec2_iam_profile" {
  name = "ec2_access_profile"
  role = aws_iam_role.ec2_role.name
}