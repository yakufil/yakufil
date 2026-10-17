resource "aws_amplify_app" "web" {
  name                     = "${var.project}-${var.environment}-web"
  repository               = "https://github.com/${var.github_repo}"
  access_token             = var.amplify_github_token != "" ? var.amplify_github_token : null
  platform                 = "WEB"
  enable_branch_auto_build = false

  build_spec = <<-EOT
    version: 1
    applications:
      - appRoot: site
        frontend:
          phases:
            build:
              commands:
                - test -f index.html
          artifacts:
            baseDirectory: .
            files:
              - '**/*'
  EOT

  environment_variables = {
    AMPLIFY_MONOREPO_APP_ROOT = "site"
  }

  lifecycle {
    ignore_changes = [access_token]
  }
}

resource "aws_amplify_branch" "web" {
  app_id            = aws_amplify_app.web.id
  branch_name       = terraform_data.deploy_branch.output
  stage             = "PRODUCTION"
  enable_auto_build = false
}
