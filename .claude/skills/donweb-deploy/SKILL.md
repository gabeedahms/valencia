---
description: Deploys the static HTML website to Donweb via FTP using lftp and .env.deploy after validating git master status.
---

# Donweb FTP Deploy Skill

Use this skill when the user asks to deploy, publish, upload, sync, or release the static website to Donweb.

## Purpose

Deploy this static HTML website to Donweb using FTP through `lftp`.

The deployment must only happen after the approved changes are committed and pushed to the `master` branch.

## Project Assumptions

- This is a static HTML/CSS/JavaScript website.
- There is no npm, package manager, build step, bundler, or framework.
- GitHub is the source of truth.
- Production branch is `master`.
- Deployment uses `scripts/deploy.sh`.
- FTP configuration is stored in `.env.deploy`.
- `lftp` is already installed locally.

## Mandatory Safety Rules

Never print, expose, edit, commit, or reveal `.env.deploy`.

Never deploy if:

- The current branch is not `master`.
- There are uncommitted changes.
- The latest changes were not pushed to `origin/master`.
- `.env.deploy` is missing.
- `scripts/deploy.sh` is missing.
- The user did not explicitly approve deployment.

Do not deploy from another branch.

Do not deploy partial or uncommitted work.

Do not upload:

- `.git/`
- `.claude/`
- `.env`
- `.env.*`
- `.env.deploy`
- `.DS_Store`
- logs
- temporary files
- local-only scripts unless intentionally required

## Deployment Procedure

When the user asks to deploy:

1. Confirm the user explicitly wants to deploy to Donweb.
2. Check current git status.
3. Check current branch.
4. Confirm the branch is `master`.
5. Confirm the working tree is clean.
6. Confirm local `master` is not behind or ahead of `origin/master`.
7. Confirm `scripts/deploy.sh` exists and is executable.
8. Confirm `.env.deploy` exists without printing its contents.
9. Run the deploy script:

```bash
./scripts/deploy.sh
