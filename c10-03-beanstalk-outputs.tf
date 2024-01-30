output "beanstalk_app_name" {
  value = aws_elastic_beanstalk_application.app.name
}

output "beanstalk_env_name" {
  value = aws_elastic_beanstalk_environment.tfenv.name
}

output "beanstalk_env_url" {
  value = aws_elastic_beanstalk_environment.tfenv.cname
}

output "beanstalk_env_instances" {
  value = aws_elastic_beanstalk_environment.tfenv.instances
}

output "beanstalk_env_platform_arn" {
  value = aws_elastic_beanstalk_environment.tfenv.platform_arn
}

output "beanstalk_env_id" {
  value = aws_elastic_beanstalk_environment.tfenv.id
}

output "beanstalk_env_endpoint_url" {
  value = aws_elastic_beanstalk_environment.tfenv.endpoint_url
}

output "beanstalk_env_SG" {
  value = [for s in aws_elastic_beanstalk_environment.tfenv.all_settings : s.value if s.name == "SecurityGroups" && s.value != ""]
}

output "beanstalk_instances" {
  value = aws_elastic_beanstalk_environment.tfenv.instances
}

# output "beanstalk_security_group_ids" {
#   value = data.aws_security_group.beanstalk_sg_ids[*].id
# }