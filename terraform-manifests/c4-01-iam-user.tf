resource "aws_iam_policy" "codecommit_vprofile_repo" {
  name        = "codecommit-vprofile-repo"
  description = "Policy to access codecommit for vprofile app"

  # Policy document
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "codecommit:CreateBranch",
                "codecommit:DeleteCommentContent",
                "codecommit:ListPullRequests",
                "codecommit:UpdatePullRequestApprovalRuleContent",
                "codecommit:PutFile",
                "codecommit:GetPullRequestApprovalStates",
                "codecommit:CreateCommit",
                "codecommit:ListTagsForResource",
                "codecommit:BatchDescribeMergeConflicts",
                "codecommit:GetCommentsForComparedCommit",
                "codecommit:DeletePullRequestApprovalRule",
                "codecommit:GetCommentReactions",
                "codecommit:GetComment",
                "codecommit:UpdateComment",
                "codecommit:MergePullRequestByThreeWay",
                "codecommit:UpdateRepositoryDescription",
                "codecommit:CreatePullRequest",
                "codecommit:UpdatePullRequestApprovalState",
                "codecommit:GetPullRequestOverrideState",
                "codecommit:PostCommentForPullRequest",
                "codecommit:GetRepositoryTriggers",
                "codecommit:UpdatePullRequestDescription",
                "codecommit:GetObjectIdentifier",
                "codecommit:BatchGetPullRequests",
                "codecommit:GetFile",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:MergePullRequestBySquash",
                "codecommit:GetDifferences",
                "codecommit:GetRepository",
                "codecommit:UpdateRepositoryName",
                "codecommit:GetMergeConflicts",
                "codecommit:GetMergeCommit",
                "codecommit:PostCommentForComparedCommit",
                "codecommit:GitPush",
                "codecommit:GetMergeOptions",
                "codecommit:AssociateApprovalRuleTemplateWithRepository",
                "codecommit:PutCommentReaction",
                "codecommit:GetTree",
                "codecommit:BatchAssociateApprovalRuleTemplateWithRepositories",
                "codecommit:CreateRepository",
                "codecommit:GetReferences",
                "codecommit:GetBlob",
                "codecommit:DescribeMergeConflicts",
                "codecommit:UpdatePullRequestTitle",
                "codecommit:ListFileCommitHistory",
                "codecommit:GetCommit",
                "codecommit:OverridePullRequestApprovalRules",
                "codecommit:GetCommitHistory",
                "codecommit:GetCommitsFromMergeBase",
                "codecommit:BatchGetCommits",
                "codecommit:TestRepositoryTriggers",
                "codecommit:DescribePullRequestEvents",
                "codecommit:UpdatePullRequestStatus",
                "codecommit:CreatePullRequestApprovalRule",
                "codecommit:UpdateDefaultBranch",
                "codecommit:GetPullRequest",
                "codecommit:PutRepositoryTriggers",
                "codecommit:UploadArchive",
                "codecommit:ListAssociatedApprovalRuleTemplatesForRepository",
                "codecommit:MergeBranchesBySquash",
                "codecommit:ListBranches",
                "codecommit:GitPull",
                "codecommit:BatchGetRepositories",
                "codecommit:DeleteRepository",
                "codecommit:GetCommentsForPullRequest",
                "codecommit:BatchDisassociateApprovalRuleTemplateFromRepositories",
                "codecommit:CancelUploadArchive",
                "codecommit:GetFolder",
                "codecommit:PostCommentReply",
                "codecommit:MergeBranchesByFastForward",
                "codecommit:CreateUnreferencedMergeCommit",
                "codecommit:EvaluatePullRequestApprovalRules",
                "codecommit:UpdateRepositoryEncryptionKey",
                "codecommit:MergeBranchesByThreeWay",
                "codecommit:GetBranch",
                "codecommit:DisassociateApprovalRuleTemplateFromRepository",
                "codecommit:MergePullRequestByFastForward",
                "codecommit:DeleteFile",
                "codecommit:DeleteBranch"
            ],
            "Resource": "${aws_codecommit_repository.spoved_vprofile_aws.arn}"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "codecommit:ListRepositoriesForApprovalRuleTemplate",
                "codecommit:CreateApprovalRuleTemplate",
                "codecommit:UpdateApprovalRuleTemplateName",
                "codecommit:GetApprovalRuleTemplate",
                "codecommit:ListApprovalRuleTemplates",
                "codecommit:DeleteApprovalRuleTemplate",
                "codecommit:ListRepositories",
                "codecommit:UpdateApprovalRuleTemplateContent",
                "codecommit:UpdateApprovalRuleTemplateDescription"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.33.0"

  name          = "vprofile-codecommit-user"

  upload_iam_user_ssh_key = true
  ssh_public_key        = file(var.public_key_path)

  
  policy_arns           = [aws_iam_policy.codecommit_vprofile_repo.arn]

#   # Inline policy to grant access to the specific CodeCommit repository
#   resource "aws_iam_user_policy" "specific_repo_access" {
#     name   = "CodeCommitSpecificRepoAccess"
#     user   = module.iam_user.this_iam_user_name
#     policy = data.aws_iam_policy_document.specific_repo_access.json
#   }
}