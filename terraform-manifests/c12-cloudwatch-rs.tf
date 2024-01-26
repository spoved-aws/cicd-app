# Cloudwatch log group for CodeBuild
resource "aws_cloudwatch_log_group" "vprofile_app" {
  name = "vproflile-logs"
}