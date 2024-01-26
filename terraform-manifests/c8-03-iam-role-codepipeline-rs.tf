# ******************* IAM role for the codepipeline *******************
resource "aws_iam_role" "vprofile_codepipeline_role" {
  name               = "vprofile-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "vprofile_codepipeline_s3_data" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject"
    ]

    resources = [
      module.s3_bucket.s3_bucket_arn,
      "${module.s3_bucket.s3_bucket_arn}/*"
    ]
  }
  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "vprofile_codepipeline_s3_policy" {
  name   = "vprofile-codepipeline_S3-policy"
  role   = aws_iam_role.vprofile_codepipeline_role.id
  policy = data.aws_iam_policy_document.vprofile_codepipeline_s3_data.json
}

# ******************* CodeCommit Policy to the pipeline *******************
data "aws_iam_policy_document" "vprofile_codepipeline_codecommit_data" {
  statement {
    effect = "Allow"

    actions = [
      "codecommit:UploadArchive",
      "codecommit:GetCommit",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:GetBranch",
      "codecommit:GetUploadArchiveStatus"
    ]

    resources = [aws_codecommit_repository.spoved_vprofile_aws.arn] # Access to the repository id 
  }
}

resource "aws_iam_role_policy" "vprofile_codepipeline_codecommit_policy" {
  name   = "vprofile-codecommit-policy"
  role   = aws_iam_role.vprofile_codepipeline_role.id
  policy = data.aws_iam_policy_document.vprofile_codepipeline_codecommit_data.json
}