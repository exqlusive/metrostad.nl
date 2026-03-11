#!/usr/bin/env bash
set -euo pipefail

SERVICE_NAME="${1:?Usage: deploy-compose-service.sh <service_name> [compose_file]}"
COMPOSE_FILE="${2:-/opt/apps/compose/production.yml}"

if [[ ! -f "$COMPOSE_FILE" ]]; then
  echo "Compose file not found: $COMPOSE_FILE" >&2
  exit 1
fi

: "${GHCR_USERNAME:?GHCR_USERNAME environment variable is required}"
: "${GHCR_PAT:?GHCR_PAT environment variable is required}"

echo "$GHCR_PAT" | docker login ghcr.io -u "$GHCR_USERNAME" --password-stdin >/dev/null

docker compose -f "$COMPOSE_FILE" pull "$SERVICE_NAME"
docker compose -f "$COMPOSE_FILE" up -d --no-deps "$SERVICE_NAME"

docker image prune -f >/dev/null || true

echo "Deployed service '$SERVICE_NAME' using '$COMPOSE_FILE'."
