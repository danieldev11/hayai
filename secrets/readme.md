# Secret Management Options

| Mode            | How to enable            | When to choose                                     |
|-----------------|--------------------------|----------------------------------------------------|
| **Doppler**     | Set env var `DOPPLER_SERVICE_TOKEN` (recommended) | Central audit log, rotation, multi-env support |
| **Compose file**| Place secret files in `secrets/<name>.txt`; keep them out of git | Air-gapped, no external SaaS |

> **Tip:** A project can switch modes at any time—just add or remove the `DOPPLER_SERVICE_TOKEN` and restart `docker compose`.
