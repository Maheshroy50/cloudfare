# ──────────────────────────────────────────────
# Module: pages
# Deploys a Cloudflare Pages project (static site)
# ──────────────────────────────────────────────

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

resource "cloudflare_pages_project" "frontend" {
  account_id        = var.account_id
  name              = var.project_name
  production_branch = var.production_branch

  deployment_configs {
    production {
      compatibility_date = var.compatibility_date

      environment_variables = merge(
        {
          WORKER_URL = var.worker_url
        },
        var.environment_variables
      )
    }
  }
}

# NOTE: Static asset deployment is handled outside Terraform.
# After `terraform apply`, upload your frontend files using Wrangler:
#
#   npx wrangler pages deploy ../  --project-name=<project_name>
#
# The environment variables above (WORKER_URL, DEPLOY_ENV, etc.)
# will be available to your Pages Functions automatically.
