variable "project" {
  description = "Project name used as a prefix for resource names"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Named profile from ~/.aws/credentials used to authenticate Terraform against AWS"
  type        = string
  default     = "default"
}

variable "environment" {
  description = "Environment name (used as a tag and resource-name suffix)"
  type        = string
  default     = "prod"
}

variable "aws_account_id" {
  description = "Optional 12-digit AWS account id. When set, Terraform refuses to apply against any other account. Leave empty to disable the guard."
  type        = string
  default     = ""
}

variable "amplify_github_token" {
  description = "Classic GitHub token with the repo and admin:repo_hook scopes. Amplify uses it one time to connect the repository. Pass it as TF_VAR_amplify_github_token on the first apply, then delete the token on GitHub"
  type        = string
  default     = ""
  sensitive   = true
}
