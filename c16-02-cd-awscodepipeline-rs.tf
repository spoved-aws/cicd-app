resource "aws_codepipeline" "vprofiles_cd" {
  name     = "vprofiles-cd-pipeline"
  role_arn = "arn:aws:iam::488429389455:role/vprofile-codepipeline-role" # this role needs access to beanstalk 
  artifact_store {
    location = "vprofile-artifact-bucket-9hf98h23f934ke342d3d3"
    type     = "S3"
  }

  stage {
    name = "Source_Checkout"

    action {
      name            = "Source"
      category        = "Source"
      owner           = "AWS"
      provider        = "CodeCommit"
      version         = "1"
      configuration = {
        BranchName            = var.cd_branch
        OutputArtifactFormat  = "CODE_ZIP"
        PollForSourceChanges  = "false"
        RepositoryName        = "spoved-vprofile-aws-ci"
      }
      output_artifacts = ["SourceArtifact"]
      run_order        = 1
    }
  }

  stage {
    name = "Test"

    action {
      name            = "Sonar_Code_Analysis"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      configuration = {
        ProjectName = "sonar-analysis"
      }
      input_artifacts  = ["SourceArtifact"]
      run_order        = 1
    }
  }

  stage {
    name = "Build_and_Store"

    action {
      name            = "BuildArtifact"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      configuration = {
        ProjectName = "artifact-build"
      }
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      run_order        = 1
    }
  }

  stage {
    name = "Deploy_to_S3"

    action {
      name            = "deploy-to-s3"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      version         = "1"
      configuration = {
        BucketName  = "vprofile-artifact-bucket-9hf98h23f934ke342d3d3"
        Extract     = "true"
        ObjectKey   = "vprofile-buildArtifacts"
      }
      input_artifacts  = ["BuildArtifact"]
      run_order        = 1
    }
  }

  stage {
    name = "Build_and_Store_for_Beanstalk"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      configuration = {
        ProjectName = "cd-build-and-release"
      }
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifactToBeanstalk"]
      run_order        = 1
    }
  }


  stage {
        name = "Deploy_to_Elastic_Beanstalk" 

        action {
            category         = "Deploy"
            configuration    = {
                "ApplicationName" = aws_elastic_beanstalk_application.app.name
                "EnvironmentName" = var.environment_name
            }
            input_artifacts  = [
                "BuildArtifactToBeanstalk",
            ]
            name             = "Deploy"
            namespace        = "DeployVariables"
            output_artifacts = []
            owner            = "AWS"
            provider         = "ElasticBeanstalk"
            region           = "us-east-1"
            run_order        = 1
            version          = "1"
        }
    }
}