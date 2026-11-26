#!/bin/bash
set -euo pipefail

# Usage:
#   ./scripts/release.sh [version] [commit_message]
# Examples:
#   ./scripts/release.sh 5.3.5
#   ./scripts/release.sh v5.3.5 "Release v5.3.5"
#   ./scripts/release.sh          # uses current version in Cargo.toml

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [ -n "${1:-}" ]; then
    VERSION="${1#v}"
    # Update version in root Cargo.toml under [workspace.package]
    sed -i -E '0,/^version = ".*"/s//version = "'"$VERSION"'"/' Cargo.toml
else
    VERSION="$(grep -m1 '^version = ' Cargo.toml | sed -E 's/version = "(.*)"/\1/')"
fi

if [ -z "$VERSION" ]; then
    echo "Error: Could not determine version."
    exit 1
fi

TAG="v$VERSION"
COMMIT_MSG="${2:-Release $TAG}"
BRANCH="$(git rev-parse --abbrev-ref HEAD)"

echo "==> Preparing release $TAG on branch $BRANCH"

# Ensure Cargo.lock is synced with Cargo.toml (prevents --frozen failure in CI)
echo "==> Syncing Cargo.lock with cargo check --offline..."
cargo check --offline

echo "==> Verifying cargo check --frozen..."
cargo check --frozen

echo "==> Staging changes..."
git add -A

if git diff --cached --quiet; then
    echo "==> No new changes to commit."
else
    echo "==> Committing: $COMMIT_MSG"
    git commit -m "$COMMIT_MSG"
fi

# Create or recreate the tag at current HEAD
if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "==> Tag $TAG already exists locally; moving it to HEAD..."
    git tag -d "$TAG"
fi
git tag -a "$TAG" -m "Release $TAG"

echo "==> Pushing $BRANCH and tag $TAG to origin..."
git push origin "$BRANCH"
git push origin "$TAG" --force

echo "==> Done! Pushed $BRANCH and $TAG. Check GitHub Actions for the CD release build."

