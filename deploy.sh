#!/usr/bin/env bash
# ──────────────────────────────────────────────
# deploy.sh — One-command deploy for Cloudflare
#   Backend  → Workers  (via Terraform)
#   Frontend → Pages    (via Terraform + Wrangler)
# ──────────────────────────────────────────────
set -euo pipefail

# ── Colors ──────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()  { echo -e "${CYAN}▶${NC} $*"; }
ok()    { echo -e "${GREEN}✔${NC} $*"; }
fail()  { echo -e "${RED}✖ $*${NC}"; exit 1; }

# ── Pre-flight checks ──────────────────────
command -v terraform >/dev/null 2>&1 || fail "terraform not found. Install: https://developer.hashicorp.com/terraform/install"
command -v npx       >/dev/null 2>&1 || fail "npx not found. Install Node.js: https://nodejs.org"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TF_DIR="$SCRIPT_DIR/terraform"
FRONTEND_DIR="$SCRIPT_DIR"

# ── Step 1: Terraform Init ─────────────────
info "Initializing Terraform..."
terraform -chdir="$TF_DIR" init -input=false -upgrade
ok "Terraform initialized"

# ── Step 2: Terraform Validate ─────────────
info "Validating Terraform configuration..."
terraform -chdir="$TF_DIR" validate
ok "Configuration valid"

# ── Step 3: Terraform Plan ─────────────────
info "Planning infrastructure changes..."
terraform -chdir="$TF_DIR" plan -input=false -out=tfplan
ok "Plan complete"

# ── Step 3: Terraform Apply ────────────────
info "Applying infrastructure (Worker + Pages project)..."
terraform -chdir="$TF_DIR" apply -input=false -auto-approve tfplan
ok "Infrastructure deployed"

# Clean up plan file
rm -f "$TF_DIR/tfplan"

# ── Step 4: Extract outputs ────────────────
WORKER_URL=$(terraform -chdir="$TF_DIR" output -raw worker_url)
PAGES_PROJECT=$(terraform -chdir="$TF_DIR" output -raw pages_project_name)

info "Worker URL:    ${BOLD}$WORKER_URL${NC}"
info "Pages project: ${BOLD}$PAGES_PROJECT${NC}"

# ── Step 5: Build frontend bundle ──────────
BUILD_DIR="$SCRIPT_DIR/_build"
info "Preparing frontend build..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Copy only frontend files
cp "$FRONTEND_DIR/index.html" "$BUILD_DIR/"
cp "$FRONTEND_DIR/style.css"  "$BUILD_DIR/"
cp "$FRONTEND_DIR/script.js"  "$BUILD_DIR/"

# Inject the Worker URL into script.js
ESCAPED_URL=$(printf '%s\n' "$WORKER_URL" | sed 's/[&/\]/\\&/g')
sed -i.bak "s|const workerUrl =.*|const workerUrl = \"$ESCAPED_URL\";|" "$BUILD_DIR/script.js"
rm -f "$BUILD_DIR/script.js.bak"
ok "Frontend build ready (Worker URL injected)"

# ── Step 6: Deploy frontend to Pages ───────
info "Deploying frontend assets to Cloudflare Pages..."
npx wrangler pages deploy "$BUILD_DIR" \
  --project-name="$PAGES_PROJECT" \
  --branch=main \
  --commit-dirty=true
ok "Frontend deployed to Pages"

# Clean up build dir
rm -rf "$BUILD_DIR"

# ── Done ───────────────────────────────────
PAGES_URL=$(terraform -chdir="$TF_DIR" output -raw pages_url)
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}║         🚀 Deployment Complete!              ║${NC}"
echo -e "${GREEN}${BOLD}╠══════════════════════════════════════════════╣${NC}"
echo -e "${GREEN}${BOLD}║${NC}  Backend:  ${CYAN}$WORKER_URL${NC}"
echo -e "${GREEN}${BOLD}║${NC}  Frontend: ${CYAN}$PAGES_URL${NC}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════╝${NC}"
