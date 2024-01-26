output "codecommit_repository_arn" {
    description = "The arn of the codecommit repo"
    value = aws_codecommit_repository.spoved_vprofile_aws.arn
}

output "codecommit_repository_id" {
    description = "The arn of the codecommit repo"
    value = aws_codecommit_repository.spoved_vprofile_aws.id
}

output "codecommit_repository_url_http" {
    description = "The arn of the codecommit repo"
    value = aws_codecommit_repository.spoved_vprofile_aws.clone_url_http
}
