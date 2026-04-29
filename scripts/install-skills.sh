#!/usr/bin/env bash
# install-skills.sh — symlink every Compose performance skill into a target
# skills directory so flat-layout skill loaders (Claude Code, Android Studio
# Agent mode, Gemini) discover them.
#
# Background. Claude Code expects ~/.claude/skills/<slug>/SKILL.md.
# This repo organizes 26 skills under <category>/<slug>/SKILL.md for human
# readability. Without symlinks the loader cannot find the SKILL.md files.
# This script flattens the layout into the target directory by symlinking
# each skill folder.
#
# Usage:
#   ./scripts/install-skills.sh                  # install to ~/.claude/skills
#   ./scripts/install-skills.sh /custom/path     # install to a custom dir
#   ./scripts/install-skills.sh --uninstall      # remove links from default target
#   ./scripts/install-skills.sh --uninstall /p   # remove links from a custom dir

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mode="install"
if [[ "${1:-}" == "--uninstall" ]]; then
  mode="uninstall"
  shift
fi
TARGET="${1:-$HOME/.claude/skills}"

if [[ "$mode" == "uninstall" ]]; then
  if [[ ! -d "$TARGET" ]]; then
    echo "Target directory does not exist: $TARGET"
    exit 0
  fi
  echo "Uninstalling Compose performance skill links from $TARGET"
  removed=0
  for link in "$TARGET"/*; do
    [[ -L "$link" ]] || continue
    target_path="$(readlink "$link")"
    if [[ "$target_path" == "$REPO_ROOT"/* ]]; then
      rm "$link"
      echo "  removed: $(basename "$link")"
      removed=$((removed + 1))
    fi
  done
  echo ""
  echo "Removed $removed symlinks."
  exit 0
fi

mkdir -p "$TARGET"
echo "Installing Compose performance skills"
echo "  source: $REPO_ROOT"
echo "  target: $TARGET"
echo ""

linked=0
skipped=0
while IFS= read -r skill_md; do
  skill_dir="$(dirname "$skill_md")"
  slug="$(basename "$skill_dir")"
  link="$TARGET/$slug"

  if [[ -L "$link" ]]; then
    skipped=$((skipped + 1))
    continue
  elif [[ -e "$link" ]]; then
    echo "  WARN: $slug already exists at $link and is not a symlink; skipping"
    skipped=$((skipped + 1))
    continue
  fi

  ln -s "$skill_dir" "$link"
  echo "  link: $slug"
  linked=$((linked + 1))
done < <(find "$REPO_ROOT" -name "SKILL.md" -type f -not -path "*/docs/*" -not -path "*/scripts/*")

echo ""
echo "Linked $linked skills, skipped $skipped."
echo "Restart Claude Code (or your agent) to pick them up."
