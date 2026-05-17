# CS Department Website — DevOps Lab Assignment
### COMSATS University Islamabad, Lahore Campus
**Course:** DevOps for Cloud Computing | **Semester:** 6 | **Section:** C

---

## 📋 Project Overview

A fully containerized static university CS department website deployed across three independent environments (Development, Staging/QA, Production) using Docker, GitHub Actions CI/CD pipelines, and Render.com hosting.

---

## 🌐 Live URLs

| Environment | URL |
|-------------|-----|
| **Production** | `https://cs-dept-prod.onrender.com` |
| **Staging/QA** | `https://cs-dept-staging.onrender.com` |
| **Development** | `https://cs-dept-dev.onrender.com` |

---

## 📁 Project Structure

```
cs-dept-website/
├── src/
│   ├── index.html          ← Home Page
│   ├── courses.html        ← Courses Page
│   ├── faculty.html        ← Faculty Page
│   ├── admissions.html     ← Admissions Page
│   └── contact.html        ← Contact Page
├── .github/
│   └── workflows/
│       ├── ci.yml                  ← CI: Lint + Docker Build
│       ├── cd-development.yml      ← CD: Deploy to Development
│       ├── cd-staging.yml          ← CD: Deploy to Staging/QA
│       └── cd-production.yml       ← CD: Deploy to Production
├── Dockerfile              ← Multi-stage Docker build
├── nginx.conf              ← Nginx server config
├── .htmlvalidate.json      ← HTML linting rules
└── README.md
```

---

## 🌿 Git Flow Branch Strategy

```
main          ← Production-ready code (protected)
  └── release/v*.*.*  ← Release candidates → Staging
        └── develop   ← Integration branch → Development
              └── feature/*  ← Individual feature branches
```

### Branch Protection Rules (configure in GitHub Settings)

| Branch | Protection |
|--------|-----------|
| `main` | Require PR + 1 review + all CI checks pass |
| `develop` | Require CI checks pass |
| `release/**` | Require PR from develop + CI pass |

---

## 🐳 Docker

### Build locally
```bash
docker build -t cs-dept-website .
```

### Run locally
```bash
docker run -p 8080:80 cs-dept-website
# Visit http://localhost:8080
```

### Multi-stage build
- **Stage 1 (lint):** Node.js 20 Alpine — HTML validation
- **Stage 2 (serve):** Nginx 1.25 Alpine — lightweight production server (~25MB)

---

## ⚙️ CI/CD Pipeline Overview

### CI Pipeline (`ci.yml`)
**Triggers:** Push/PR to `develop`, `release/**`, `main`

| Job | Steps |
|-----|-------|
| **lint** | Install html-validate → validate all 5 HTML files → check CSS variables |
| **docker-build** | Build Docker image → run container → health check all pages → report image size |
| **ci-summary** | Print summary of all job results |

### CD — Development (`cd-development.yml`)
**Triggers:** Push to `develop`
1. Login to Docker Hub → build & push `dev-latest` tag
2. Trigger Render deploy hook
3. Wait 60s → verify URL responds HTTP 200

### CD — Staging (`cd-staging.yml`)
**Triggers:** Push to `release/**`
1. Extract version from branch name (e.g. `release/v1.2.0`)
2. Build & push `staging-v1.2.0` tag
3. Run QA smoke tests on all 5 pages locally
4. Trigger Render staging deploy hook
5. Verify staging URL

### CD — Production (`cd-production.yml`)
**Triggers:** Push to `main`
1. Pre-deploy checks (verify all pages + Dockerfile exist)
2. Build & push `latest` and `prod-<sha>` tags
3. **Manual approval gate** via GitHub Environment `production`
4. Trigger Render production deploy hook
5. Retry URL verification 3× with 30s intervals

---

## 🔐 GitHub Environments & Secrets

### Create Three Environments
Go to **Repo → Settings → Environments** and create:

1. `development`
2. `staging`
3. `production` ← Add required reviewers here (approval gate)

### Required Secrets (per environment)

| Secret | Description |
|--------|-------------|
| `DOCKER_USERNAME` | Docker Hub username |
| `DOCKER_PASSWORD` | Docker Hub password or access token |
| `RENDER_DEPLOY_HOOK_DEV` | Render deploy hook URL (dev service) |
| `RENDER_DEPLOY_HOOK_STAGING` | Render deploy hook URL (staging service) |
| `RENDER_DEPLOY_HOOK_PROD` | Render deploy hook URL (production service) |
| `DEV_SITE_URL` | e.g. `https://cs-dept-dev.onrender.com` |
| `STAGING_SITE_URL` | e.g. `https://cs-dept-staging.onrender.com` |
| `PROD_SITE_URL` | e.g. `https://cs-dept-prod.onrender.com` |

---

## 🚀 Render.com Setup

### Create 3 Web Services

For each environment, create a **new Web Service** on Render.com:

1. **Connect** your GitHub repository
2. **Environment:** Docker
3. **Branch:** (irrelevant — we use deploy hooks)
4. **Dockerfile Path:** `./Dockerfile`

| Service Name | Branch | Environment |
|---|---|---|
| `cs-dept-dev` | `develop` | Development |
| `cs-dept-staging` | `release/v*` | Staging |
| `cs-dept-prod` | `main` | Production |

### Get Deploy Hook URLs
For each service: **Service → Settings → Deploy Hook → Copy URL**
Add each URL to the corresponding GitHub Environment secret.

---

## 👥 Team Contributions

| # | Name | Roll No. | Role | Page | Workflow |
|---|------|----------|------|------|----------|
| 1 | Team Lead | — | Lead | Home Page (`index.html`) | `ci.yml` |
| 2 | Member 2 | — | Developer | Courses (`courses.html`) | `cd-development.yml` |
| 3 | Member 3 | — | Developer | Faculty (`faculty.html`) | `cd-staging.yml` |
| 4 | Member 4 | — | Developer | Admissions (`admissions.html`) | `cd-production.yml` |
| 5 | Member 5 | — | Developer | Contact (`contact.html`) | Docker + Nginx |

---

## 📊 Evaluation Checklist

- [x] Public GitHub repository
- [x] Git Flow branching (develop, release/*, main)
- [x] 5 complete HTML/CSS web pages
- [x] Dockerfile (multi-stage, Nginx-based)
- [x] CI pipeline: HTML linting + Docker build + health check
- [x] CD pipeline for Development (triggers on `develop`)
- [x] CD pipeline for Staging/QA (triggers on `release/**`)
- [x] CD pipeline for Production (triggers on `main` + approval gate)
- [x] GitHub Environments (development, staging, production)
- [x] Secrets managed via GitHub Environment secrets
- [x] Render.com deploy hooks for each environment
- [x] Branch protection rules configured
- [x] README documentation

---

## 🛠️ Local Development

```bash
# Clone repo
git clone https://github.com/<your-org>/cs-dept-website.git
cd cs-dept-website

# Start on develop branch
git checkout develop

# Create a feature branch
git checkout -b feature/your-page

# Edit files in src/
# ...

# Commit and push
git add .
git commit -m "feat: add contact page"
git push origin feature/your-page

# Open a Pull Request to develop on GitHub
```

---

*COMSATS University Islamabad, Lahore Campus — DevOps for Cloud Computing Lab Assignment*
