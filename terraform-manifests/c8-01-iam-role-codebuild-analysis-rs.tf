# ******************* IAM role for codebuild analysis project *******************
resource "aws_iam_role" "codebuild_analysis_role" {
    name = "codebuild-sonar-analysis-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Action = "sts:AssumeRole",
            Effect = "Allow",
            Principal = {
            Service = "codebuild.amazonaws.com"
            }
        },
        ]
    })
}


resource "aws_iam_role_policy" "codebuild_analysis_ssm_policy" {
  name   = "codebuild_analysis_ssm_s3_codecommit_logs"
  role   = aws_iam_role.codebuild_analysis_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "SSMAccess",
        Action = [
          "ssm:DescribeParameters",
          "ssm:GetParameterHistory",
          "ssm:DescribeDocumentParameters",
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Sid      = "S3Access",
        Effect   = "Allow",
        Action   = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation",
          "s3:GetObjectVersion"
        ],
        Resource = "arn:aws:s3:::vprofile-artifact-bucket-9hf98h23f934ke342d3d3/*"
      },
      {
        Sid      = "CloudWatchLogsAccess",
        Effect   = "Allow",
        Resource = [
          aws_cloudwatch_log_group.vprofile_app.arn,
          "${aws_cloudwatch_log_group.vprofile_app.arn}:*"
        ],
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        Sid      = "CodeCommitAccess",
        Effect   = "Allow",
        Resource = ["arn:aws:codecommit:us-east-1:488429389455:spoved-vprofile-ci"],
        Action   = ["codecommit:GitPull"]
      }
    ]
  })
}