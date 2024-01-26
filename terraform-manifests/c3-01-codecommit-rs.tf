resource "aws_codecommit_repository" "spoved_vprofile_aws" {
  repository_name = "spoved-vprofile-aws-ci"
  description     = "repository for AWS CI"
}