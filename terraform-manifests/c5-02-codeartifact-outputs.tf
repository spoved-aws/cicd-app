output "codeartifact_repo_arn" {
    description = "The arn of the codeArtifact repo"
    value = aws_codeartifact_repository.spoved_vprofile_artifact.arn
}
