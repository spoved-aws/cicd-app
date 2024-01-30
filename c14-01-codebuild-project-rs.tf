# ******************* Code Build Project for Code Analysis *******************
resource "aws_codebuild_project" "cd_build_release" {
  name                   = "cd-build-and-release"
  service_role           = "arn:aws:iam::488429389455:role/codebuild-buildartifact-role"
  source_version         = "refs/heads/cd-aws"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type      = "CODECOMMIT"
    location  = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/spoved-vprofile-aws-ci"
    buildspec           = <<-EOT
            version: 0.2
            env:
              parameter-store:
                CODEARTIFACT_AUTH_TOKEN: CODEARTIFACT_AUTH_TOKEN
                dbhost: rds-endpoint
                dbuser: RDSUSER
                dbpass: RDSPASS
            phases:
              install:
                runtime-versions:
                  java: corretto8
                commands:
                  - cp ./settings.xml /root/.m2/settings.xml
              pre_build:
                commands:
                  - sed -i "s/jdbc.password=admin123/jdbc.password=$dbpass/" src/main/resources/application.properties
                  - sed -i "s/jdbc.username=admin/jdbc.username=$dbuser/" src/main/resources/application.properties
                  - sed -i "s/db01:3306/$dbhost:3306/" src/main/resources/application.properties
                  - apt-get update
                  - apt-get install -y jq
                  - wget https://downloads.apache.org/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz
                  - tar xzf apache-maven-3.8.8-bin.tar.gz
                  - ln -s apache-maven-3.8.8 maven
              build:
                commands:
                  - mvn clean install -DskipTests
            artifacts:
              files:
                - '**/*'
              base-directory: 'target/vprofile-v2'
        EOT
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "vproflile-logs"
      stream_name = "build-and-release"
      status      = "ENABLED"
    }
  }
}
