# ******************* Code Build Project for Code Analysis *******************
resource "aws_codebuild_project" "sonar_analysis" {
  name                   = "sonar-analysis"
  service_role           = aws_iam_role.codebuild_analysis_role.arn
  source_version         = "refs/heads/ci-aws"

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
    location  = aws_codecommit_repository.spoved_vprofile_aws.clone_url_http
    buildspec           = <<-EOT
            version: 0.2
            env:
              parameter-store:
                LOGIN: sonartoken
                HOST: Host
                Organization: Organization
                Project: Project
                CODEARTIFACT_AUTH_TOKEN: CODEARTIFACT_AUTH_TOKEN
            phases:
              install:
                runtime-versions:
                  java: corretto8
                commands:
                - cp ./settings.xml /root/.m2/settings.xml
              pre_build:
                commands:
                  - apt-get update
                  - apt-get install -y jq checkstyle
                  - wget https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz
                  - tar xzvf apache-maven-3.9.4-bin.tar.gz
                  - ln -s apache-maven-3.9.4 maven
                  - wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.3.0.1492-linux.zip
                  - unzip ./sonar-scanner-cli-3.3.0.1492-linux.zip
                  - export PATH=$PATH:/sonar-scanner-3.3.0.1492-linux/bin/
              build:
                commands:
                  - mvn test
                  - mvn checkstyle:checkstyle
                  - echo "Installing JDK11 as its a dependency for sonarqube code analysis"
                  - apt-get install -y openjdk-17-jdk
                  - export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
                  - mvn sonar:sonar -Dsonar.login=$LOGIN -Dsonar.host.url=$HOST -Dsonar.projectKey=$Project -Dsonar.organization=$Organization -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ -Dsonar.junit.reportsPath=target/surefire-reports/ -Dsonar.jacoco.reportsPath=target/jacoco.exec -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml
                  # - mvn sonar:sonar -Dsonar.login=4c3b556cef2fc9c3a41399d181173dbb1de57238 -Dsonar.host.url=https://sonarcloud.io -Dsonar.projectKey=spoved-sonar-vprofile -Dsonar.organization=spoved-sonar-vprofile -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ -Dsonar.junit.reportsPath=target/surefire-reports/ -Dsonar.jacoco.reportsPath=target/jacoco.exec -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml
                  - sleep 5
                  - curl https://sonarcloud.io/api/qualitygates/project_status?projectKey=$Project >result.json
                  - cat result.json
                  - if [ $(jq -r '.projectStatus.status' result.json) = ERROR ] ; then $CODEBUILD_BUILD_SUCCEEDING -eq 0 ;fi
        EOT
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.vprofile_app.name
      stream_name = "sonar-analysis-stream"
      status      = "ENABLED"
    }
  }
}
# ******************* Code Build Project for ArtifactBuild *******************
resource "aws_codebuild_project" "artifact_build" {
  name             = "artifact-build"
  service_role    = aws_iam_role.codebuild_buildartifact_role.arn
  source_version  = "refs/heads/ci-aws"

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
    location  = aws_codecommit_repository.spoved_vprofile_aws.clone_url_http
    buildspec = <<-EOT
        version: 0.2
        env: 
          parameter-store:
            CODEARTIFACT_AUTH_TOKEN: CODEARTIFACT_AUTH_TOKEN
        phases:
          install:
            runtime-versions:
              java: corretto8
            commands:
              - cp ./settings.xml /root/.m2/settings.xml
          pre_build:
            commands:
              - apt-get update
              - apt-get install -y jq 
              - wget https://dlcdn.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz
              - tar xzvf apache-maven-3.9.4-bin.tar.gz
              - ln -s apache-maven-3.9.4 maven
          build:
            commands:
              - mvn clean install -DskipTests
        artifacts:
          files:
            - target/**/*.war
          discard-paths: yes
      EOT
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.vprofile_app.name
      stream_name = "artifact-build-stream"
      status      = "ENABLED"
    }
  }
}
