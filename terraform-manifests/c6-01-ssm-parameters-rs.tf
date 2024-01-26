resource "aws_ssm_parameter" "organization" {
  name  = "Organization "
  type  = "String"
  value = "spoved-sonar-vprofile"
}
resource "aws_ssm_parameter" "host" {
  name  = "Host"
  type  = "String"
  value = "https://sonarcloud.io"
}
resource "aws_ssm_parameter" "project" {
  name  = "Project"
  type  = "String"
  value = "spoved-sonar-vprofile"
}
resource "aws_ssm_parameter" "sonar_token" {
  name  = "sonartoken"
  type  = "SecureString"
  value = var.sonar_token_var
}
