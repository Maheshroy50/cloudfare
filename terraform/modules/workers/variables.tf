# ──────────────────────────────────────────────
# Module: workers – Input Variables
# ──────────────────────────────────────────────

variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "api_token" {
  description = "Cloudflare API token (used for enabling workers.dev subdomain)"
  type        = string
  sensitive   = true
}

variable "worker_name" {
  description = "Name of the Worker script (appears in the dashboard & URL)"
  type        = string
}

variable "script_content" {
  description = "JavaScript source code of the Worker"
  type        = string
}

variable "environment" {
  description = "Environment label (dev / staging / production)"
  type        = string
  default     = "production"
}

variable "zone_id" {
  description = "Cloudflare Zone ID (required only if using a custom route)"
  type        = string
  default     = ""
}

variable "route_pattern" {
  description = "Route pattern for the Worker (e.g. api.example.com/*)"
  type        = string
  default     = ""
}

variable "workers_subdomain" {
  description = "Your workers.dev subdomain (find in dashboard → Workers & Pages)"
  type        = string
}
