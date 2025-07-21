#!/usr/bin/env bash
# install.sh – Hayai Tier 1 one-liner installer
set -euo pipefail

echo "[Installer] Starting Hayai install …"

# ----- 1 ▪ Secret management mode ------------------------------------------
if [[ -n "${DOPPLER_SERVICE_TOKEN:-}" ]]; then
  echo "[Installer] Using Doppler for secret injection"
  USE_DOPPLER=true
else
  echo "[Installer] No Doppler token found – falling back to Compose secrets/"
  USE_DOPPLER=false
fi

# ----- 2 ▪ Install Doppler CLI if needed ------------------------------------
if [[ "$USE_DOPPLER" == "true" ]]; then
  curl -Ls https://cli.doppler.com/install.sh | sh
  doppler configure set service_token "$DOPPLER_SERVICE_TOKEN"
fi

# ----- 3 ▪ Fetch repo & start stack -----------------------------------------
REPO_DIR=/opt/leadflow
if [[ ! -d "$REPO_DIR" ]]; then
  git clone --depth=1 https://github.com/danieldev11/hayai.git "$REPO_DIR"
fi
cd "$REPO_DIR"
if [[ "$USE_DOPPLER" == "true" ]]; then
  doppler run -- docker compose up -d
else
  docker compose up -d
fi

echo "[Installer] ✅  Install finished. Services should be up."
