resource "aws_codepipeline" "vprofiles_ci" {
  name     = "vprofiles-ci-pipeline"
  role_arn = aws_iam_role.vprofile_codepipeline_role.arn
  artifact_store {
    location = module.s3_bucket.s3_bucket_id
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name            = "Source"
      category        = "Source"
      owner           = "AWS"
      provider        = "CodeCommit"
      version         = "1"
      configuration = {
        BranchName            = "ci-aws"
        OutputArtifactFormat  = "CODE_ZIP"
        PollForSourceChanges  = "false"
        RepositoryName        = aws_codecommit_repository.spoved_vprofile_aws.repository_name
      }
      output_artifacts = ["SourceArtifact"]
      run_order        = 1
    }
  }

  stage {
    name = "Test"

    action {
      name            = "Sonar-Code-Analysis"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      configuration = {
        ProjectName = aws_codebuild_project.sonar_analysis.name
      }
      input_artifacts  = ["SourceArtifact"]
      run_order        = 1
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      configuration = {
        ProjectName = aws_codebuild_project.artifact_build.name
      }
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      run_order        = 1
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "deploy-to-s3"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      version         = "1"
      configuration = {
        BucketName  = module.s3_bucket.s3_bucket_id
        Extract     = "true"
        ObjectKey   = aws_s3_object.builddir.key
      }
      input_artifacts  = ["BuildArtifact"]
      run_order        = 1
    }
  }
}



