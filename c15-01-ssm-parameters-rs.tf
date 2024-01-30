resource "aws_ssm_parameter" "rds_endpoint" {
  name  = "rds-endpoint "
  type  = "String"
  value = "vprofile-mysql-db.c308iyi8sim9.us-east-1.rds.amazonaws.com"
}
resource "aws_ssm_parameter" "RDSUSER" {
  name  = "RDSUSER"
  type  = "String"
  value = "admin"
}
resource "aws_ssm_parameter" "RDSPASS" {
  name  = "RDSPASS"
  type  = "SecureString"
  value = "dbpass12345667"
}
