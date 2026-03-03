# ──────────────────────────────────────────────
# Root Variables
# ──────────────────────────────────────────────

variable "cloudflare_api_token" {
  description = "Cloudflare API token with Workers Scripts:Edit and Pages:Edit permissions"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID (find in dashboard → Overview → right sidebar)"
  type        = string
}

# ── Worker settings ──────────────────────────

variable "worker_name" {
  description = "Name for the backend Worker (becomes <name>.<subdomain>.workers.dev)"
  type        = string
  default     = "mahesh-backend-worker"
}

variable "environment" {
  description = "Deployment environment label"
  type        = string
  default     = "production"
}

variable "workers_subdomain" {
  description = "Your workers.dev subdomain (find in Cloudflare dashboard → Workers & Pages)"
  type        = string
}

# ── Pages settings ───────────────────────────

variable "pages_project_name" {
  description = "Name for the Cloudflare Pages project (becomes <name>.pages.dev)"
  type        = string
  default     = "mahesh-frontend"
}

variable "production_branch" {
  description = "Git branch treated as production for Pages"
  type        = string
  default     = "main"
}

# ── Optional: custom domain routing ──────────

variable "zone_id" {
  description = "Cloudflare Zone ID (only needed for custom domain routing)"
  type        = string
  default     = ""
}

variable "worker_route_pattern" {
  description = "Custom route pattern for the Worker (e.g. api.example.com/*)"
  type        = string
  default     = ""
}
