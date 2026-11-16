#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="reality-check"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${SCRIPT_DIR}/skills/${SKILL_NAME}"

usage() {
  cat <<EOF
Usage: ./install.sh [target]

Targets:
  antigravity   Install to ~/.gemini/config/skills/${SKILL_NAME}
                (also ~/.agents/skills/${SKILL_NAME} for workspace-level discovery)
  claude        Install to ~/.claude/skills/${SKILL_NAME}
  codex         Install to ~/.codex/skills/${SKILL_NAME}
  cursor        Install to ~/.cursor/skills/${SKILL_NAME}
  hermes        Install to ~/.hermes/skills/${SKILL_NAME}
  all           Install to every platform above
  <path>        Install to a custom project root (into <path>/.agents/skills/${SKILL_NAME})

Example:
  ./install.sh all
  ./install.sh hermes
  ./install.sh /path/to/my-project
EOF
}

install_to_dir() {
  local dest="$1"
  # Guard: never operate on an empty or obviously wrong path
  if [ -z "$dest" ] || [ "$dest" = "/" ] || [ "$dest" = "$HOME" ]; then
    echo "❌ Refusing to install to unsafe path: '${dest}'" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$dest")"
  rm -rf "$dest"
  cp -R "$SOURCE_DIR" "$dest"
  echo "✅ Installed ${SKILL_NAME} to: ${dest}"
}

TARGET="${1:-all}"

case "$TARGET" in
  -h|--help|help)
    usage
    ;;
  antigravity|agy)
    install_to_dir "${HOME}/.gemini/config/skills/${SKILL_NAME}"
    install_to_dir "${HOME}/.agents/skills/${SKILL_NAME}"
    ;;
  claude)
    install_to_dir "${HOME}/.claude/skills/${SKILL_NAME}"
    ;;
  codex)
    install_to_dir "${HOME}/.codex/skills/${SKILL_NAME}"
    ;;
  cursor)
    install_to_dir "${HOME}/.cursor/skills/${SKILL_NAME}"
    ;;
  hermes)
    install_to_dir "${HOME}/.hermes/skills/${SKILL_NAME}"
    ;;
  all)
    install_to_dir "${HOME}/.gemini/config/skills/${SKILL_NAME}"
    install_to_dir "${HOME}/.agents/skills/${SKILL_NAME}"
    install_to_dir "${HOME}/.claude/skills/${SKILL_NAME}"
    install_to_dir "${HOME}/.codex/skills/${SKILL_NAME}"
    install_to_dir "${HOME}/.cursor/skills/${SKILL_NAME}"
    install_to_dir "${HOME}/.hermes/skills/${SKILL_NAME}"
    ;;
  *)
    if [ -d "$TARGET" ]; then
      install_to_dir "${TARGET%/}/.agents/skills/${SKILL_NAME}"
    else
      echo "❌ Unknown target or non-existent directory: $TARGET" >&2
      usage
      exit 1
    fi
    ;;
esac
