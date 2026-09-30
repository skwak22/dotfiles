#!/usr/bin/env bash
# Idempotently ensures the GitHub CLI (`gh`) is installed in ~/.local/bin/gh
# without requiring root/sudo privileges, and reports authentication status.
set -euo pipefail

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

if ! command -v gh >/dev/null 2>&1; then
  echo "[gh-pr] 'gh' not found on PATH; installing latest release to ~/.local/bin/gh..."
  GH_VERSION="$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest | jq -r '.tag_name' | sed 's/^v//')"
  OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *)
      echo "[gh-pr] ERROR: Unsupported architecture: $ARCH" >&2
      exit 1
      ;;
  esac

  TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "$TMP_DIR"' EXIT

  if [[ "$OS" == "darwin" ]]; then
    ARCHIVE="gh_${GH_VERSION}_macOS_${ARCH}.zip"
    curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/${ARCHIVE}" -o "${TMP_DIR}/${ARCHIVE}"
    unzip -q "${TMP_DIR}/${ARCHIVE}" -d "${TMP_DIR}"
    BIN_PATH="${TMP_DIR}/gh_${GH_VERSION}_macOS_${ARCH}/bin/gh"
  else
    ARCHIVE="gh_${GH_VERSION}_${OS}_${ARCH}.tar.gz"
    curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/${ARCHIVE}" -o "${TMP_DIR}/${ARCHIVE}"
    tar -xzf "${TMP_DIR}/${ARCHIVE}" -C "${TMP_DIR}"
    BIN_PATH="${TMP_DIR}/gh_${GH_VERSION}_${OS}_${ARCH}/bin/gh"
  fi

  mkdir -p "$HOME/.local/bin"
  install -m 0755 "$BIN_PATH" "$HOME/.local/bin/gh"
  echo "[gh-pr] Installed $(gh --version | head -n 1) to $HOME/.local/bin/gh"
else
  echo "[gh-pr] Found $(gh --version | head -n 1) at $(command -v gh)"
fi

# Detect GitHub hostname from origin remote if inside a git repo
GH_HOST="github.com"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  ORIGIN_URL="$(git remote get-url origin 2>/dev/null || true)"
  if [[ "$ORIGIN_URL" =~ ^git@([^:]+): ]]; then
    GH_HOST="${BASH_REMATCH[1]}"
  elif [[ "$ORIGIN_URL" =~ ^https?://([^/]+)/ ]]; then
    GH_HOST="${BASH_REMATCH[1]}"
  fi
fi

if gh auth status --hostname "$GH_HOST" >/dev/null 2>&1; then
  echo "[gh-pr] Authenticated with $GH_HOST"
else
  echo "[gh-pr] AUTH_REQUIRED: Not logged into $GH_HOST. Run: gh auth login --hostname $GH_HOST"
  exit 2
fi
