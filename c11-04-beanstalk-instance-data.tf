data "aws_instance" "first_instance" {
  instance_id = aws_elastic_beanstalk_environment.tfenv.instances[0]
}

output "first_instance_security_group_id" {
  value = tolist(data.aws_instance.first_instance.vpc_security_group_ids)[0]
}


output "is_string" {
  value = can(tolist(data.aws_instance.first_instance.vpc_security_group_ids)[0]) ? true : false
}