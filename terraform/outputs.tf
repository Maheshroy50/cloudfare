# ──────────────────────────────────────────────
# Root Outputs
# ──────────────────────────────────────────────

output "worker_name" {
  description = "Deployed Worker script name"
  value       = module.workers.worker_name
}

output "worker_url" {
  description = "Backend Worker URL (*.workers.dev)"
  value       = module.workers.worker_url
}

output "pages_url" {
  description = "Frontend Pages URL (*.pages.dev)"
  value       = module.pages.pages_url
}

output "pages_project_name" {
  description = "Cloudflare Pages project name"
  value       = module.pages.pages_project_name
}

output "deployment_summary" {
  description = "Quick summary of deployed resources"
  value = <<-EOT

    ╔══════════════════════════════════════════════╗
    ║       Cloudflare Deployment Summary          ║
    ╠══════════════════════════════════════════════╣
    ║  Backend  (Worker) : ${module.workers.worker_url}
    ║  Frontend (Pages)  : ${module.pages.pages_url}
    ║  Environment       : ${var.environment}
    ╚══════════════════════════════════════════════╝

    Next step: Update script.js with the Worker URL above.
  EOT
}
