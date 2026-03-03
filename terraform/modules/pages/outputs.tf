# ──────────────────────────────────────────────
# Module: pages – Outputs
# ──────────────────────────────────────────────

output "pages_project_name" {
  description = "Cloudflare Pages project name"
  value       = cloudflare_pages_project.frontend.name
}

output "pages_url" {
  description = "Live Pages URL (*.pages.dev)"
  value       = "https://${cloudflare_pages_project.frontend.name}.pages.dev"
}

output "pages_subdomain" {
  description = "Pages subdomain"
  value       = cloudflare_pages_project.frontend.subdomain
}
