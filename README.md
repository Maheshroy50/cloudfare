# 🚀 Cloudflare Full-Stack Demo — Terraform Deployment

Deploy a **static frontend** to **Cloudflare Pages** and a **backend API** to **Cloudflare Workers**, fully managed with **modular Terraform**.

---

## 📐 Architecture

```
┌──────────────┐         HTTPS          ┌──────────────────┐
│   Browser    │ ──────────────────────► │  Cloudflare      │
│              │                         │  Pages (Frontend) │
│              │                         │  *.pages.dev      │
└──────┬───────┘                         └──────────────────┘
       │
       │  fetch("/api")
       ▼
┌──────────────────┐
│  Cloudflare      │
│  Worker (Backend) │
│  *.workers.dev    │
└──────────────────┘
```

| Layer    | Technology        | Files                          | URL Pattern          |
| -------- | ----------------- | ------------------------------ | -------------------- |
| Frontend | Cloudflare Pages  | `index.html`, `script.js`, `style.css` | `<name>.pages.dev`   |
| Backend  | Cloudflare Workers | `terraform/worker-src/index.js` | `<name>.workers.dev` |

---


---

## 🚀 Deployment Steps

### 1. Configure Variables

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your actual values:

```hcl
cloudflare_api_token  = "your-actual-api-token"
cloudflare_account_id = "your-actual-account-id"
worker_name           = "mahesh-backend-worker"
pages_project_name    = "mahesh-frontend"
environment           = "production"
```

### 2. Initialize Terraform

```bash
terraform init
```

This downloads the Cloudflare provider plugin.

### 3. Review the Plan

```bash
terraform plan
```

You'll see the resources to be created:
- `cloudflare_worker_script.backend`
- `cloudflare_pages_project.frontend`

### 4. Deploy

```bash
terraform apply
```

Type `yes` to confirm. Terraform will output:

```
worker_url  = "https://mahesh-backend-worker.<account>.workers.dev"
pages_url   = "https://mahesh-frontend.pages.dev"
```

### 5. Update Frontend Worker URL

After deploy, copy the `worker_url` from the output and update `script.js`:

```javascript
const workerUrl = "https://mahesh-backend-worker.<account>.workers.dev";
```

Then redeploy Pages (or push to git if using git integration).

### 6. Upload Frontend to Pages

Since we use `direct_upload`, push your static files via the Cloudflare dashboard or Wrangler CLI:

```bash
# From the project root (cloudfare/)
npx wrangler pages deploy . --project-name=mahesh-frontend
```

---

## 🧩 Terraform Modules

### `modules/workers`

Deploys a Cloudflare Worker script with optional custom route.

| Variable         | Required | Default        | Description                        |
| ---------------- | -------- | -------------- | ---------------------------------- |
| `account_id`     | ✅       | —              | Cloudflare Account ID              |
| `worker_name`    | ✅       | —              | Worker script name                 |
| `script_content` | ✅       | —              | JavaScript source code             |
| `environment`    | ❌       | `"production"` | Environment label                  |
| `zone_id`        | ❌       | `""`           | Zone ID for custom routing         |
| `route_pattern`  | ❌       | `""`           | Route pattern (e.g. `api.x.com/*`) |

**Outputs:** `worker_name`, `worker_url`

### `modules/pages`

Deploys a Cloudflare Pages project for static frontend hosting.

| Variable               | Required | Default        | Description                          |
| ---------------------- | -------- | -------------- | ------------------------------------ |
| `account_id`           | ✅       | —              | Cloudflare Account ID                |
| `project_name`         | ✅       | —              | Pages project name                   |
| `production_branch`    | ❌       | `"main"`       | Git branch for production            |
| `compatibility_date`   | ❌       | `"2026-03-01"` | Workers compat date                  |
| `worker_url`           | ❌       | `""`           | Backend URL (injected as env var)    |
| `environment_variables`| ❌       | `{}`           | Additional env vars                  |
| `frontend_assets_path` | ❌       | `"../../"`     | Path to static files                 |

**Outputs:** `pages_project_name`, `pages_url`, `pages_subdomain`

---

## 🔄 Common Operations

### Destroy All Resources

```bash
cd terraform
terraform destroy
```

### Update Worker Code Only

Edit `terraform/worker-src/index.js`, then:

```bash
terraform apply -target=module.workers
```

### Update Pages Config Only

```bash
terraform apply -target=module.pages
```

### View Current State

```bash
terraform show
terraform output
```


