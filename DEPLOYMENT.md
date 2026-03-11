# metrostad.nl Deployment (Laravel)

This repo uses the shared VPS deployment contract.

## Defaults

- Service name: `metrostad-nl`
- Shared script: `/opt/apps/bin/deploy-compose-service.sh`
- Shared compose file: `/opt/apps/compose/production.yml`

## Trigger behavior

- Push to `acceptance`: builds tag `:acceptance` and deploys to acceptance.
- Push to `main`: builds tag `:main` and deploys to production.
- Manual run (`workflow_dispatch`): run it from the branch you want to deploy.

## Required GitHub secrets

Shared:
- `GHCR_USERNAME`
- `GHCR_PAT` (scope: `read:packages`)

Production:
- `PROD_HOST`
- `PROD_PORT`
- `PROD_USER`
- `PROD_SSH_KEY`

Acceptance:
- `ACC_HOST`
- `ACC_PORT`
- `ACC_USER`
- `ACC_SSH_KEY`

## Optional GitHub variables

- `DEPLOY_SERVICE_NAME`
- `DEPLOY_SCRIPT`
- `DEPLOY_COMPOSE_FILE`
- `ACC_DEPLOY_COMPOSE_FILE` (if acceptance uses a different compose file path)

## Example compose service

```yaml
services:
  metrostad-nl:
    image: ghcr.io/exqlusive/metrostad.nl:main
    container_name: metrostad-nl
    restart: unless-stopped
    env_file:
      - /opt/apps/env/metrostad-nl.env
    # Optional: expose directly (skip if using a reverse proxy network)
    # ports:
    #   - "8080:80"
```

This image now runs Laravel via FrankenPHP (Caddy + PHP in one container).
Add Redis, worker/scheduler services separately in the same stack.

Use `ghcr.io/exqlusive/metrostad.nl:acceptance` in the acceptance compose file.
