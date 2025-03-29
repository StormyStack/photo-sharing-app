resource "aws_elastic_beanstalk_application" "photo_app" {
  name        = "photo-sharing-app"
  description = "Flask-based photo sharing app deployed on AWS Elastic Beanstalk"
}

resource "aws_elastic_beanstalk_application_version" "photo_app_version" {
  name        = var.app_version
  application = aws_elastic_beanstalk_application.photo_app.name
  bucket      = var.app_bucket_name
  key         = var.s3_object_key
  description = "Version 1.0 of the photo-sharing app"
}

resource "aws_elastic_beanstalk_environment" "photo_app_env" {
  name                = "photo-app-env"
  application         = aws_elastic_beanstalk_application.photo_app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.5.0 running Python 3.12"
  version_label       = aws_elastic_beanstalk_application_version.photo_app_version.name

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  /*setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "LoadBalancerName"
    value     = var.my_alb_name
  }*/

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.beanstalk_iam_profile_name
  }

  setting {
    namespace = "aws:elasticbeanstalk:container:python"
    name      = "NumProcesses"
    value     = "3"
  }

  setting {
    namespace = "aws:elasticbeanstalk:container:python"
    name      = "NumThreads"
    value     = "20"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "2"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "4"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.subnet_ids)
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = var.eb_sg_id
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "S3_BUCKET_NAME"
    value     = var.s3_bucket_name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DYNAMODB_TABLE_NAME"
    value     = var.dynamodb_table_name
  }
}
