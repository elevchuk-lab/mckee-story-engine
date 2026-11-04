#!/bin/sh
# Robert McKee Story Engine — One-Line Installer for Claude Code & Google Antigravity
# Usage: curl -fsSL https://raw.githubusercontent.com/elevchuk-lab/mckee-story-engine/main/install.sh | sh

set -e

REPO_RAW="https://raw.githubusercontent.com/elevchuk-lab/mckee-story-engine/main/skills/mckee-story-engine"

install_to_dir() {
  TARGET_DIR="$1"
  mkdir -p "$TARGET_DIR/references"
  curl -fsSL "$REPO_RAW/SKILL.md" -o "$TARGET_DIR/SKILL.md"
  curl -fsSL "$REPO_RAW/references/1-story-architecture.md" -o "$TARGET_DIR/references/1-story-architecture.md"
  curl -fsSL "$REPO_RAW/references/2-character-design.md" -o "$TARGET_DIR/references/2-character-design.md"
  curl -fsSL "$REPO_RAW/references/3-dialogue-and-subtext.md" -o "$TARGET_DIR/references/3-dialogue-and-subtext.md"
  curl -fsSL "$REPO_RAW/references/4-storynomics-and-teardown.md" -o "$TARGET_DIR/references/4-storynomics-and-teardown.md"
  printf "✓ Installed mckee-story-engine to %s\n" "$TARGET_DIR"
}

echo "Installing Robert McKee Story Engine (Tetralogy Edition)..."

# 1. Install to ~/.claude/skills (Claude Code global skills)
CLAUDE_DIR="$HOME/.claude/skills/mckee-story-engine"
install_to_dir "$CLAUDE_DIR"

# 2. If inside a workspace with .agent/skills, install there as well
if [ -d ".agent" ]; then
  AGY_DIR=".agent/skills/mckee-story-engine"
  install_to_dir "$AGY_DIR"
fi

echo "Done! You can now use [DEEP TEARDOWN], [STORYNOMICS], [ARCHITECT], and [SCRIPT DOCTOR] modes."
