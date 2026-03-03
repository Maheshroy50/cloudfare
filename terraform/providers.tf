# ──────────────────────────────────────────────
# Terraform Provider Configuration
# ──────────────────────────────────────────────

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  # Optional: uncomment for remote state
  # backend "s3" {
  #   bucket   = "your-terraform-state-bucket"
  #   key      = "cloudfare/terraform.tfstate"
  #   region   = "auto"
  #   endpoint = "https://<account_id>.r2.cloudflarestorage.com"
  # }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
