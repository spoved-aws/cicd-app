resource "aws_iam_role" "beanstalk_service_role" {
    name = "vprofile-elasticbeanstalk-service-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Action = "sts:AssumeRole",
            Effect = "Allow",
            Principal = {
            Service = "elasticbeanstalk.amazonaws.com"
            }
        },
        ]
    })
    managed_policy_arns   = ["arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy",
                             "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
    ]
}

resource "aws_iam_role" "beanstalk_EC2_role" {
    name = "vprofile-elasticbeanstalk-ec2-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Action = "sts:AssumeRole",
            Effect = "Allow",
            Principal = {
            Service = "ec2.amazonaws.com"
            }
        },
        ]
    })
    managed_policy_arns   = ["arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier",
                             "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier",
                             "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
    ]
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "vprofile-instance-role"
  role = aws_iam_role.beanstalk_EC2_role.name
}