resource "aws_codeartifact_repository" "spoved_vprofile_artifact" {
  depends_on = [aws_codeartifact_domain.spoved_vprofile]
  repository = "spoved-vprofile-awsci"
  domain     = aws_codeartifact_domain.spoved_vprofile.domain

  upstream {
        repository_name = aws_codeartifact_repository.maven_upstream.repository
    }
}

resource "aws_codeartifact_domain" "spoved_vprofile" {
  domain         = "spoved-vprofile"
#   encryption_key = aws_kms_key.example.arn
}

resource "aws_codeartifact_repository" "maven_upstream" {
  depends_on = [aws_codeartifact_domain.spoved_vprofile]
  repository = "maven-central-store"
  domain     = aws_codeartifact_domain.spoved_vprofile.domain

  external_connections {
    external_connection_name = "public:maven-central"
  }
}