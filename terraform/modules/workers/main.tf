# ──────────────────────────────────────────────
# Module: workers
# Deploys a Cloudflare Worker script
# ──────────────────────────────────────────────

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

resource "cloudflare_workers_script" "backend" {
  account_id = var.account_id
  name       = var.worker_name
  content    = var.script_content
  module     = true # ES-module format

  plain_text_binding {
    name = "ENVIRONMENT"
    text = var.environment
  }
}

# Optional: custom route (e.g. api.yourdomain.com/*) 
resource "cloudflare_workers_route" "backend_route" {
  count       = var.zone_id != "" && var.route_pattern != "" ? 1 : 0
  zone_id     = var.zone_id
  pattern     = var.route_pattern
  script_name = cloudflare_workers_script.backend.name
}

# Enable *.workers.dev subdomain (no native TF resource — uses API)
resource "terraform_data" "enable_workers_dev" {
  depends_on = [cloudflare_workers_script.backend]

  # Re-run if the worker name changes
  input = cloudflare_workers_script.backend.name

  provisioner "local-exec" {
    command = <<-EOT
      curl -s -X POST \
        "https://api.cloudflare.com/client/v4/accounts/${var.account_id}/workers/scripts/${var.worker_name}/subdomain" \
        -H "Authorization: Bearer ${var.api_token}" \
        -H "Content-Type: application/json" \
        -d '{"enabled": true}'
    EOT
  }
}
