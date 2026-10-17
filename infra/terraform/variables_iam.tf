variable "github_repo" {
  description = "GitHub repo in <owner>/<name> form"
  type        = string
}

variable "github_branch" {
  description = "The one branch whose workflows may use the deploy role: main or master, never both. After the first apply it cannot change"
  type        = string
  default     = "main"

  validation {
    condition     = contains(["main", "master"], var.github_branch)
    error_message = "github_branch must be main or master."
  }
}

variable "github_oidc_sub_prefix" {
  description = "The sub_claim_prefix from `gh api repos/<owner>/<name>/actions/oidc/customization/sub`, in the immutable form repo:<owner>@<owner id>/<name>@<repo id>"
  type        = string

  validation {
    condition     = can(regex("^repo:[^/@]+@[0-9]+/[^/@]+@[0-9]+$", var.github_oidc_sub_prefix))
    error_message = "github_oidc_sub_prefix must be the immutable form repo:<owner>@<owner id>/<name>@<repo id>."
  }
}
