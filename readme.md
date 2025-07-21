# AI‑LeadFlow Platform — Private AI‑Automation PaaS

> Drops a revenue‑generating lead‑flow engine into any business in minutes.
> Built for instant time‑to‑value (Tier 1) with an upgrade path to full single‑tenant compliance (Tier 2).

---

## 📚 Table of Contents

* [🚀 What Is This?](#-what-is-this)
* [🧩 Core Features](#-core-features)
* [🎯 Tiers & Positioning](#-tiers--positioning)
* [🔨 Tech Stack](#-tech-stack)
* [🖥️ Prerequisites](#️-prerequisites)
* [⚡ Quick Start (Tier 1)](#-quick-start-tier-1)
* [🌐 Environment Variables](#-environment-variables)
* [↩️ Uninstall / Rollback](#️-uninstall--rollback)
* [📁 Repository Layout](#-repository-layout)
* [🔄 Deployment Flow](#-deployment-flow)
* [🩺 Monitoring & Alerts](#-monitoring--alerts)
* [🛡️ Security & Compliance](#️-security--compliance)
* [🛠️ Versioning & Changelog](#️-versioning--changelog)
* [🗺️ Roadmap (Q3 → Q4 2025)](#️-roadmap-q3--q4-2025)
* [🆘 Support](#-support)
* [🤝 Contributing](#-contributing)
* [📜 License](#-license)

---

## 🚀 What Is This?

**AI‑LeadFlow** is an automation platform that installs a fully‑wired lead‑generation and booking system (workflows + dashboards + telephony) with one command.

It targets SMBs that need results now, then scales to enterprise‑grade, single‑tenant deployments when compliance knocks.

---

## 🧩 Core Features

* **One‑click installer**:
  `curl -sSL https://install.ai-leadflow.com \| bash`
* **Pre‑built n8n workflows**: capture → enrich → qualify → book
* **Outcome dashboards**: map marketing spend → booked revenue
* **Voice‑AI ready**: Twilio by default, swap to Retell/Bento for 70% savings
* **Flat, predictable billing**: enforced via Helicone usage caps

---

## 🎯 Tiers & Positioning

| Tier       | Who It’s For           | Brief                                                                                        | Status     |
| ---------- | ---------------------- | -------------------------------------------------------------------------------------------- | ---------- |
| **Tier 1** | SMBs, pilots           | Multi‑tenant stack we host (n8n, Supabase, Twilio, Grafana Cloud). Fast setup, flat pricing. | ✅ GA       |
| **Tier 2** | Compliance-heavy orgs  | Single‑tenant, Terraform-provisioned into client’s AWS/GCP infra.                            | 🧪 Beta Q4 |
| **Tier 0** | Agencies (white-label) | Optional GoHighLevel resale wrapper (upsell).                                                | 📝 Planned |

We **lead with Tier 1**.
Tier 0 is optional upsell.
Tier 2 is the **long-term enterprise path**.

---

## 🔨 Tech Stack

| Layer           | Default             | Notes                                |
| --------------- | ------------------- | ------------------------------------ |
| Workflow Engine | n8n                 | Low‑/no‑code, JSON exportable        |
| IaC             | Terraform & Ansible | Tier 2 only                          |
| Containers      | Docker + Compose    | Auto‑patched via Watchtower          |
| Data            | Supabase (Postgres) | RLS + HIPAA compliance pack          |
| Cache / Queue   | Redis               | Job queueing + rate-limiting         |
| Telephony       | Twilio / Retell     | Twilio for speed, Retell for margins |
| Observability   | Grafana Alloy Cloud | No Prometheus babysitting            |

---

## 🖥️ Prerequisites

* Docker 24+ and Compose plugin
* 4 GB RAM & 2 vCPU minimum
* Outbound HTTPS (443) to:

  * `ai-leadflow.com`, `hub.docker.com`, `supabase.io`, `twilio.com`
* *(Optional)* Twilio SID with \$20 credit (for voice/SMS day-1)

---

## ⚡ Quick Start (Tier 1)

```bash
# 1. Install Docker
https://docs.docker.com/engine/install/

# 2. Run the one-liner installer
curl -sSL https://install.ai-leadflow.com | bash

# 3. Follow the printed URL → complete 3-step business wizard
```

> The wizard seeds Supabase, imports workflows, and validates Twilio.

You’ll get:

* Admin URL + login token
* Docker Compose health check status
* Daily usage cap notice (Helicone)

---

## 🌐 Environment Variables

> Either export at runtime or place in `.env`.

```bash
SUPABASE_URL="https://XYZ.supabase.co"
SUPABASE_KEY="your-anon-key"
TWILIO_SID="ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
TWILIO_TOKEN="xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
OPENAI_API_KEY="sk-..."
```

See `.env.example` for a template.

---

## ↩️ Uninstall / Rollback

```bash
# Stop & remove containers
cd /opt/ai-leadflow && docker compose down

# (Optional) Remove volumes
docker volume rm ailedflow_supabase ailedflow_redis ...
```

To rollback, restore your latest Supabase S3 backup (see `docs/restore.md`).

---

## 📁 Repository Layout

```
.
├─ installer/        # Bash + Ansible installer
├─ compose/          # Docker Compose bundles
│   ├─ tier-1.yaml   # n8n, Supabase, Redis, Alloy
│   └─ tier-2.yaml   # ECS/Fargate modules
├─ workflows/        # n8n JSON exports
├─ terraform/        # Tier-2 IaC modules
├─ docs/             # Diagrams, runbooks
└─ scripts/          # CI smoke tests & linting
```

---

## 🔄 Deployment Flow

* Commit & push → CI (GitHub Actions) builds and tests
* Tag a version (e.g. `v1.4.2`) → CD job publishes to GHCR
* Watchtower auto-pulls, runs `/health` smoke test
* Blue-green cutover via DNS (CNAME swap)

---

## 🩺 Monitoring & Alerts

* n8n errors >5 in 10 min → `#alerts` Slack
* Supabase P95 latency >300 ms → Ops email
* Twilio balance <\$20 → SMS owner

> All metrics shipped via Grafana Alloy Cloud

---

## 🛡️ Security & Compliance

| Control            | Tier 1                     | Tier 2                         |
| ------------------ | -------------------------- | ------------------------------ |
| Encrypted Backups  | Nightly S3 (AES‑256)       | Customer S3/GCS                |
| Row-Level Security | ✔️ Supabase RLS            | ✔️ Supabase RLS                |
| Audit Logs         | Supabase → Logflare (30 d) | Forwarded to customer SIEM     |
| PHI Isolation      | HIPAA pack (auto-enabled)  | HIPAA pack + network isolation |
| Secret Management  | Docker secrets             | HashiCorp Vault / Doppler      |
| SSO                | Email magic link           | OIDC / SAML                    |

> 📎 See `docs/security/HIPAA.md` for full checklist.

---

## 🛠️ Versioning & Changelog

Follows [Semantic Versioning 2.0.0](https://semver.org):
`MAJOR.MINOR.PATCH` → see `CHANGELOG.md` for release history.

* Patch = backward-compatible
* Minor = might need migration
* Major = breaking changes

---

## 🗺️ Roadmap (Q3 → Q4 2025)

| Milestone                    | Owner      | KPI                         | ETA          |
| ---------------------------- | ---------- | --------------------------- | ------------ |
| Retell Voice POC (GPU-based) | DevOps     | <2 s latency @ <\$0.004/min | Oct 31, 2025 |
| Self-hosted Ollama fallback  | Platform   | 99.9 % LLM uptime           | Nov 15, 2025 |
| SOC 2 Type I readiness       | Compliance | Draft controls 100%         | Dec 1, 2025  |
| Workflow marketplace launch  | Product    | ≥5 paid packs live          | Dec 20, 2025 |

---

## 🆘 Support

* [Join Slack](https://join.slack.com/t/ai-leadflow/shared_invite/...)
* [Status Page](https://status.ai-leadflow.com)
* 📩 Email: `support@ai-leadflow.com`

---

## 🤝 Contributing

1. Fork → branch → PR
2. Follow `docs/STYLEGUIDE.md`
3. Must pass:

   ```bash
   ./scripts/lint.sh
   ./scripts/test.sh
   ```

---

## 📜 License

**Commercial License** — contact `sales@ai-leadflow.com` for terms.

---

> Built with ❤️ & extreme automation.
