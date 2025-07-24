# Hayai — Private AI-Automation PaaS

![Build](https://github.com/danieldev11/hayai/actions/workflows/build.yml/badge.svg)
![Lint](https://github.com/danieldev11/hayai/actions/workflows/lint.yml/badge.svg)

*Deep-dive engineering guide.*

> Looking for business-level docs? See [README.md](README.md).

---

## 1. Repository Layout

The Hayai codebase is organized as a monorepo with the following structure:

```text
hayai/
├── apps/              # Next.js frontend and API routes
│   ├── web/           # Main web application
│   ├── admin/         # Admin dashboard
│   └── api/           # API routes and services
├── packages/          # Agent SDK and shared UI components
│   ├── agent-sdk/     # Agent tooling and interfaces
│   ├── ui/            # Component library
│   └── utils/         # Shared utilities
├── infra/            
│   ├── compose/       # Docker Compose files (Tier 1)
│   ├── terraform/     # Terraform IaC (Tier 2/3)
│   └── helm/          # Kubernetes charts (Tier 3)
├── scripts/           # Build, deployment and utility scripts
└── .github/
    └── workflows/     # CI/CD pipeline definitions
```

## 2. Tier Matrix

Hayai offers three runtime environments with increasing levels of isolation, compliance, and scalability:

| Feature | Tier 1 | Tier 2 | Tier 3 |
| ------- | ------ | ------ | ------ |
| **Deployment** | Local Docker Compose | AWS ECS + Fargate | Kubernetes (EKS/GKE) |
| **Database** | Local Supabase | AWS RDS (Postgres) | AWS Aurora or GCP AlloyDB |
| **Secrets** | .env files | AWS Secrets Manager | HashiCorp Vault |
| **Observability** | Local Grafana | Grafana Cloud | DataDog + PagerDuty |
| **Authentication** | Magic Links | OIDC | SAML + MFA |
| **Workflows** | Local Redis | AWS Step Functions | Temporal |
| **Scalability** | Single Instance | Auto-scaling | Multi-region |
| **Compliance** | Basic | SOC 2 | SOC 2 + HIPAA |

## 3. Environment Variables

The application requires various environment variables depending on the tier:

```bash
# Core (All Tiers)
OPENAI_API_KEY=sk-...
SUPABASE_URL=https://xyz.supabase.co
SUPABASE_SERVICE_ROLE=eyJhbGc...
TWILIO_ACCOUNT_SID=AC...
TWILIO_AUTH_TOKEN=...

# Tier 2/3
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
VAULT_TOKEN=hvs...
TEMPORAL_NAMESPACE=hayai

# Optional
HELICONE_API_KEY=...  # For LLM usage tracking
SENTRY_DSN=...        # For error tracking
```

Run `pnpm generate:env` to generate `.env` files from Terraform outputs.

## 4. Deployment Flow (Blue-Green)

Our Git-based deployment flow ensures zero-downtime updates:

1. Push to `main` branch triggers the CI pipeline
2. CI runs tests, builds the application, and pushes Docker images to registry
3. CD deploys to the "blue" infrastructure (staging)
4. Automated health checks validate the deployment
5. If healthy, the CNAME is switched to point to the new "blue" deployment
6. The old "green" deployment is preserved for quick rollback if needed

For rollback, run:

```bash
make deploy.rollback ENV=production
```

## 5. CI/CD Pipeline

We use GitHub Actions for our build/release pipeline:

- **CI**: `build.yml`, `test.yml`, `lint.yml`, `docker.yml`
- **CD**: `deploy.yml`, `release.yml`

Short-lived deployment tokens are fetched from HashiCorp Vault during CI runs.

Pull requests are blocked if:

- Test coverage falls below 80%
- Linting errors exist
- Any unit or integration test fails

## 6. Infrastructure as Code

Our infrastructure is defined as code in `infra/terraform`:

```text
terraform/
├── modules/
│   ├── database/
│   ├── compute/
│   ├── network/
│   └── monitoring/
├── environments/
│   ├── staging/
│   └── production/
└── terragrunt.hcl    # Shared configuration
```

To apply changes:

```bash
cd infra/terraform/environments/production
make tf.plan    # Review changes
make tf.apply   # Apply changes
```

## 7. Monitoring & Alerts

Alert rules are defined in `infra/monitoring/alerts.yaml` and synced via CI:

| Category | Alert | Threshold | Notification |
| -------- | ----- | --------- | ----------- |
| API | HTTP 5xx Rate | >1% for 5m | Slack #alerts, PagerDuty |
| Bookings | Dropout Rate | >5% for 15m | Slack #bookings |
| Twilio | Balance | <$20 | Email to ops@ |
| Temporal | Workflow Failures | Any | Slack #workflows, Email |
| Database | P95 Latency | >300ms for 10m | Slack #db, PagerDuty |

## 8. Versioning & Changelog

We follow Semantic Versioning 2.0:

- **Patch** (1.0.x): Backwards compatible bug fixes, auto-deployed
- **Minor** (1.x.0): New features, backwards compatible, requires human approval
- **Major** (x.0.0): Breaking changes, requires migration plan and approval

We use `semantic-release` to automate versioning based on commit messages.

## 9. Contributing

Developer workflow:

1. Create feature branch (`feat/booking-widget`, `fix/auth-timeout`)
2. Set up local dev environment with `make dev`
3. Pre-commit hooks ensure linting (eslint, Prettier) and tests pass
4. Write tests for new features (Vitest for unit, Playwright for E2E)
5. Submit PR with linked issue, squash merge after approval

## 10. License

- **Default**: MIT License (see LICENSE.md)
- **Tier 3**: May include dual licensing for enterprise features

Contact [security@hayai.run](mailto:security@hayai.run) for SOC2/HIPAA compliance details.

## 11. Support

- **Developer Slack**: Channels `#dev` and `#ops`
- **Status Page**: [https://status.hayai.run](https://status.hayai.run)
- **Email**: [support@hayai.run](mailto:support@hayai.run) (24/7 for Tier 3 customers)

---

## Appendix: Quick Commands

```bash
# Local development
make dev                   # Start local development environment
pnpm test                  # Run all tests
pnpm test:watch            # Run tests in watch mode

# Deployment
make deploy ENV=staging    # Deploy to staging
make deploy ENV=production # Deploy to production
make logs ENV=production   # View production logs

# Infrastructure
make tf.plan ENV=production  # Plan infrastructure changes
make tf.apply ENV=production # Apply infrastructure changes
```
