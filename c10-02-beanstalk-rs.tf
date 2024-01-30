resource "aws_elastic_beanstalk_application" "app" {
  depends_on = [ aws_iam_role.beanstalk_EC2_role,
                aws_iam_role.beanstalk_service_role
               ]
  name = "vprofile-bs-application"

  appversion_lifecycle {
    service_role          = aws_iam_role.beanstalk_service_role.arn
    max_count             = 128
    delete_source_from_s3 = true
  }
}

resource "aws_elastic_beanstalk_environment" "tfenv" {
  name                = var.environment_name
  application         = aws_elastic_beanstalk_application.app.name
  platform_arn        = "arn:aws:elasticbeanstalk:us-east-1::platform/Tomcat 10 with Corretto 17 running on 64bit Amazon Linux 2023/5.1.3"
  # platform_arn        = "arn:aws:elasticbeanstalk:us-east-1::platform/Tomcat 8.5 with Corretto 11 running on 64bit Amazon Linux 2/4.4.0"
  #solution_stack_name = "64bit Amazon Linux 2 v5.4.4 running Tomcat 8.5 Corretto 11"

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t3.micro"
  }

  setting {
    namespace = "aws:cloudformation:template:parameter"
    name      = "InstanceTypeFamily"
    value     = "t3"
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t3.micro, t3.small"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.beanstalk_service_role.arn
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ServiceRoleForManagedUpdates"
    value     = aws_iam_role.beanstalk_service_role.arn
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ec2_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "nexus-ec2"
  }
}


