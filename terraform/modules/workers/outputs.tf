# ──────────────────────────────────────────────
# Module: workers – Outputs
# ──────────────────────────────────────────────

output "worker_name" {
  description = "Deployed Worker script name"
  value       = cloudflare_workers_script.backend.name
}

output "worker_url" {
  description = "Default *.workers.dev URL for the Worker"
  value       = "https://${cloudflare_workers_script.backend.name}.${var.workers_subdomain}.workers.dev"
}
