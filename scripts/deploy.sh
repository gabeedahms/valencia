#!/usr/bin/env bash
set -euo pipefail

ENV_FILE=".env.deploy"

if ! command -v lftp >/dev/null 2>&1; then
  echo "Deploy blocked: lftp is not installed."
  exit 1
fi

if [ ! -f "$ENV_FILE" ]; then
  echo "Deploy blocked: missing .env.deploy file."
  exit 1
fi

# Load FTP config without printing secrets.
set -a
source "$ENV_FILE"
set +a

: "${FTP_HOST:?FTP_HOST is required}"
: "${FTP_USER:?FTP_USER is required}"
: "${FTP_PASS:?FTP_PASS is required}"
: "${FTP_REMOTE_DIR:?FTP_REMOTE_DIR is required}"

CURRENT_BRANCH="$(git branch --show-current)"

if [ "$CURRENT_BRANCH" != "main" ]; then
  echo "Deploy blocked: current branch is '$CURRENT_BRANCH', expected 'main'."
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "Deploy blocked: working tree has uncommitted changes."
  git status --short
  exit 1
fi

git fetch origin main >/dev/null 2>&1

LOCAL_COMMIT="$(git rev-parse main)"
REMOTE_COMMIT="$(git rev-parse origin/main)"

if [ "$LOCAL_COMMIT" != "$REMOTE_COMMIT" ]; then
  echo "Deploy blocked: local main is not synced with origin/main."
  echo "Local:  $LOCAL_COMMIT"
  echo "Remote: $REMOTE_COMMIT"
  exit 1
fi

echo "Deploying commit $LOCAL_COMMIT from main to Donweb..."

# Inline all.css into index.html en un directorio temporal para eliminar
# el request HTTP bloqueante — mejora LCP en ~990ms en Donweb.
DEPLOY_DIR="$(mktemp -d)"
trap 'rm -rf "$DEPLOY_DIR"' EXIT
cp -r ./public_html/. "$DEPLOY_DIR/"
python3 - <<PYEOF
import re, pathlib
css  = pathlib.Path('public_html/all.css').read_text()
idx  = pathlib.Path('public_html/index.html').read_text()
inlined = idx.replace(
    '<link rel="stylesheet" href="all.css">',
    '<style>' + css + '</style>'
)
pathlib.Path('$DEPLOY_DIR/index.html').write_text(inlined)
PYEOF
echo "CSS inlineado en index.html para deploy."

lftp -u "$FTP_USER","$FTP_PASS" "$FTP_HOST" <<EOF
set ftp:ssl-allow no
set net:timeout 20
set net:max-retries 2
set net:reconnect-interval-base 5

mirror -R \
  --verbose \
  --delete \
  --exclude-glob .git/ \
  --exclude-glob .claude/ \
  --exclude-glob .env \
  --exclude-glob ".env.*" \
  --exclude-glob .env.deploy \
  --exclude-glob .DS_Store \
  --exclude-glob "*.log" \
  --exclude-glob "tmp/" \
  --exclude-glob "temp/" \
  --exclude-glob "cgi-bin/" \
  --exclude-glob ".ht_leame" \
  --exclude-glob ".htpasswd" \
  $DEPLOY_DIR/ "$FTP_REMOTE_DIR"

bye
EOF

echo "Deploy completed successfully."
echo "Branch: main"
echo "Commit: $LOCAL_COMMIT"