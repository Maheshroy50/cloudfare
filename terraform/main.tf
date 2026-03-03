# ──────────────────────────────────────────────
# Root Module – Wires Workers + Pages modules
# ──────────────────────────────────────────────

locals {
  # Read the Worker source at plan time
  worker_script = file("${path.module}/worker-src/index.js")
}

# ── Backend: Cloudflare Worker ───────────────
module "workers" {
  source = "./modules/workers"

  account_id        = var.cloudflare_account_id
  api_token         = var.cloudflare_api_token
  worker_name       = var.worker_name
  script_content    = local.worker_script
  environment       = var.environment
  zone_id           = var.zone_id
  route_pattern     = var.worker_route_pattern
  workers_subdomain = var.workers_subdomain
}

# ── Frontend: Cloudflare Pages ───────────────
module "pages" {
  source = "./modules/pages"

  account_id          = var.cloudflare_account_id
  project_name        = var.pages_project_name
  production_branch   = var.production_branch
  worker_url          = module.workers.worker_url

  environment_variables = {
    DEPLOY_ENV = var.environment
  }
}
