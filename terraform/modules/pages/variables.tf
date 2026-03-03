# ──────────────────────────────────────────────
# Module: pages – Input Variables
# ──────────────────────────────────────────────

variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "project_name" {
  description = "Cloudflare Pages project name (appears in URL as <name>.pages.dev)"
  type        = string
}

variable "production_branch" {
  description = "Git branch treated as production"
  type        = string
  default     = "main"
}

variable "compatibility_date" {
  description = "Workers compatibility date for Pages Functions"
  type        = string
  default     = "2026-03-01"
}

variable "worker_url" {
  description = "Backend Worker URL to inject as an environment variable"
  type        = string
  default     = ""
}

variable "environment_variables" {
  description = "Additional environment variables for the Pages project"
  type        = map(string)
  default     = {}
}
