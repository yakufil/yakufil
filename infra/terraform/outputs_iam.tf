output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions_deploy.arn
  description = "Set as the GitHub Actions repo variable AWS_DEPLOY_ROLE_ARN"
}

output "deploy_branch" {
  value       = terraform_data.deploy_branch.output
  description = "Set as the GitHub Actions repo variable DEPLOY_BRANCH"
}
