# Hayai — Private AI-Automation Platform-as-a-Service

![Build](https://github.com/danieldev11/hayai/actions/workflows/build.yml/badge.svg)
![Lint](https://github.com/danieldev11/hayai/actions/workflows/lint.yml/badge.svg)
![coverage](https://img.shields.io/badge/coverage-85%25-brightgreen.svg)

Instant booking + workflow engine you can drop into any business in minutes.

---

## Table of Contents

* [Why Hayai?](#why-hayai)
* [Quick Start](#quick-start)
* [Tech Stack & Architecture](#tech-stack--architecture)
* [Pricing](#pricing)
* [Monitoring & Alerts](#monitoring--alerts)
* [Security & Compliance](#security--compliance)
* [Roadmap](#roadmap)
* [FAQ](#faq)
* [Contributors & License](#contributors--license)
* [Status & Badges](#status--badges)

> **PDF readers:** Links point to the public repo [https://github.com/hayai/booking](https://github.com/hayai/booking). If a link doesn't open, please visit the URL directly.

---

## Why Hayai?

* **Instant setup** – deploy in under 60 seconds
* **Maximize conversions** – AI-agent-optimised booking flows
* **Enterprise ready** – tiered stack, observability, rollback & compliance

---

## Quick Start

**Prerequisites:** Docker 24+, Node.js 18+

```bash
# one-liner installer
curl -s https://get.hayai.run | bash
```

Or clone the repo and bring the stack up **detached**:

```bash
git clone https://github.com/hayai/booking.git
cd booking
docker compose up -d
# Ctrl-C to exit logs
# docker compose down   # to stop and remove containers
```

The full environment template lives in the [environment example file](https://github.com/hayai/booking/blob/main/.env.example). Key variables:

| Variable                                  | Purpose                       |
| ---------------------------------------- | ----------------------------- |
| `OPENAI_API_KEY`                          | Power LLM agents              |
| `SUPABASE_URL`, `SUPABASE_SERVICE_ROLE`   | Database + row-level security |
| `TWILIO_ACCOUNT_SID`, `TWILIO_AUTH_TOKEN` | SMS / voice notifications     |
| `HELICONE_API_KEY`                        | *(optional)* Usage logging    |

---

## Tech Stack & Architecture

| Component    | Description                  | Tier |
| ------------ | ---------------------------- | ---- |
| Next.js      | UI layer with server actions | 1    |
| Supabase     | DB, auth & realtime          | 1    |
| Postgres     | Core data store              | 1    |
| Twilio       | SMS / voice notifications    | 1    |
| Temporal     | Workflow orchestration       | 2    |
| Grafana/Loki | Observability (metrics/logs) | 2    |
| Vault        | Secrets management           | 3    |

This stack keeps your agents snappy at the seed stage and scales to enterprise workloads.

> Need architecture & CI details? See [DEVELOPER.md](DEVELOPER.md).

> See [DEPLOYMENT.md](https://github.com/hayai/booking/blob/main/DEPLOYMENT.md) for Terraform modules, multi-tier compose files & rollback guides.

## Pricing

| Tier           | Features                                | Monthly |
| -------------- | --------------------------------------- | ------- |
| **Starter**    | 1 agent · email reminders               | Free    |
| **Pro**        | Unlimited agents · SMS · webhooks       | \$49    |
| **Enterprise** | Dedicated stack · compliance · 24/7 SLA | Custom  |

---

## Monitoring & Alerts

* **Prometheus** metrics at `/metrics`
* **Grafana** dashboards (Loki logs + Tempo traces)
* **Alertmanager** rules for:
  * Agent failures
  * Booking drop-outs
  * Third-party downtime (Twilio / Supabase)

---

## Security & Compliance

| Domain  | Feature                             | Tier |
| ------- | ----------------------------------- | ---- |
| Auth    | JWT + Supabase RLS                  | 1    |
| Secrets | Encrypted `.env`; Vault integration | 2/3  |
| Logs    | Structured + PII-redacted           | 2    |
| Audit   | HIPAA & SOC 2 *(in progress)*       | 3    |

---

## Roadmap

| Milestone             | Target 2025 | Status     |
| --------------------- | ----------- | ---------- |
| Tiered deployments    | Q1          | � Done     |
| Agent SDK             | Q1          | � Done     |
| Cal.com plugin        | Q2          | 🔜 Planned |
| SOC 2 & HIPAA audits  | Q3          | 🔜 Planned |
| Partner dashboard     | Q3          | 🔜 Planned |
| Marketplace templates | Q4          | ⏳ Scoping  |
| Admin reporting panel | Q4          | ⏳ Scoping  |

---

## FAQ

**Why are my Twilio messages failing?**  
Check sandbox status and ensure `TWILIO_*` secrets are correct and active.

**Supabase row-level security errors?**  
Make sure every policy references `auth.role()` and that `SUPABASE_SERVICE_ROLE` is set.

**Can I run without OpenAI?**  
Yes—agents can route to human operators or direct calendar links. Disable the OpenAI integration to run "LLM-free".

---

## Contributors & License

This project is licensed under the **SPDX-License-Identifier: MIT** license.  
Released under the MIT License. Contributions welcome via PR or issues.

* **Slack:** [join the community](https://join.slack.com/t/hayai-dev/shared_invite)
* **Status page:** [https://status.hayai.run](https://status.hayai.run)
* **Contributing guide:** [CONTRIBUTING.md](https://github.com/danieldev11/hayai/blob/main/CONTRIBUTING.md)

## Status & Badges

![build](https://github.com/hayai/booking/actions/workflows/build.yml/badge.svg)
![license](https://img.shields.io/github/license/danieldev11/hayai)
![uptime](https://img.shields.io/endpoint?url=https://status.hayai.run/api/badge)
