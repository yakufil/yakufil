output "amplify_app_id" {
  value       = aws_amplify_app.web.id
  description = "Set as the GitHub Actions repo variable AMPLIFY_APP_ID"
}

output "web_url" {
  value       = "https://${aws_amplify_branch.web.branch_name}.${aws_amplify_app.web.default_domain}"
  description = "Public URL of the web"
}
