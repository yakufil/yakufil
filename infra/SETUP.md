# One-time setup

Do these steps one time, in this order. After them, a push to the deploy
branch that changes `site/**` runs `deploy-web.yml`.

## 1. GitHub repository

Create the repository and push the deploy branch (`main` or `master`, not
both). Read the OIDC subject prefix of the repository. A repository created
after 15 July 2026 has the immutable form `repo:<owner>@<owner id>/<name>@<repo id>`.

```bash
gh api repos/<owner>/<repo>/actions/oidc/customization/sub --jq .sub_claim_prefix
```

## 2. Terraform

Give the Amplify GitHub App for the region access to this repository:
`https://github.com/apps/aws-amplify-<region>/installations/new`.
Then make a new classic GitHub token with the `repo` and `admin:repo_hook` scopes.

```bash
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
TF_VAR_amplify_github_token=<the token> terraform apply
```

Amplify uses the token one time to connect the repository. Delete the token on
GitHub after the apply. A later `terraform apply` needs no token.

The first apply locks `github_branch`. A later apply with the other branch
fails, so only one branch can ever use the deploy role.

## 3. GitHub

```bash
gh variable set AWS_DEPLOY_ROLE_ARN --body "$(terraform output -raw github_actions_role_arn)"
gh variable set AMPLIFY_APP_ID --body "$(terraform output -raw amplify_app_id)"
gh variable set DEPLOY_BRANCH --body "$(terraform output -raw deploy_branch)"
```

The workflow gets a temporary AWS key through the deploy role. `deploy.py`
starts the Amplify build. The web is public, so the deploy sends no values.

## 4. First deploy

Run the workflow once by hand (Actions, "Run workflow").
