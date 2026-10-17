data "aws_iam_policy_document" "github_actions_amplify" {
  statement {
    sid       = "AmplifyRelease"
    effect    = "Allow"
    actions   = ["amplify:StartJob", "amplify:GetJob"]
    resources = ["${aws_amplify_branch.web.arn}/jobs/*"]
  }
}

resource "aws_iam_role_policy" "github_actions_amplify" {
  name   = "amplify-release"
  role   = aws_iam_role.github_actions_deploy.id
  policy = data.aws_iam_policy_document.github_actions_amplify.json
}
