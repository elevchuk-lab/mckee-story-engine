#!/bin/sh
# Robert McKee Story Engine — One-Line Installer for Claude Code & Google Antigravity
# Usage: curl -fsSL https://raw.githubusercontent.com/elevchuk-lab/mckee-story-engine/main/install.sh | sh

set -e

REPO_RAW="${MCKEE_REPO_RAW:-https://raw.githubusercontent.com/elevchuk-lab/mckee-story-engine/main/skills/mckee-story-engine}"
MV_CMD="${MCKEE_MV_CMD:-mv}"

STAGE_DIR="$(mktemp -d "${TMPDIR:-/tmp}/mckee_stage.XXXXXX")"
ACTIVE_TARGET=""
ACTIVE_BACKUP=""
ACTIVE_TMP_NEW=""

cleanup() {
  if [ -n "$ACTIVE_TARGET" ] && [ ! -e "$ACTIVE_TARGET" ] && [ -n "$ACTIVE_BACKUP" ] && [ -d "$ACTIVE_BACKUP" ]; then
    mv "$ACTIVE_BACKUP" "$ACTIVE_TARGET" 2>/dev/null || true
  fi
  if [ -n "$ACTIVE_TMP_NEW" ] && [ -d "$ACTIVE_TMP_NEW" ]; then
    rm -rf "$ACTIVE_TMP_NEW"
  fi
  if [ -n "$STAGE_DIR" ] && [ -d "$STAGE_DIR" ]; then
    rm -rf "$STAGE_DIR"
  fi
}

handle_signal() {
  SIG_EXIT_CODE="$1"
  trap - EXIT INT TERM HUP
  cleanup
  exit "$SIG_EXIT_CODE"
}

trap cleanup EXIT
trap 'handle_signal 130' INT
trap 'handle_signal 143' TERM
trap 'handle_signal 129' HUP

echo "Installing Robert McKee Story Engine (Complete Pentalogy Edition)..."
echo "==> Downloading skill files to temporary staging directory..."

mkdir -p "$STAGE_DIR/references"

FILES="
SKILL.md
references/1-story-architecture.md
references/2-character-design.md
references/3-dialogue-and-subtext.md
references/4-storynomics-and-teardown.md
references/5-action-suspense-and-pacing.md
"

for rel_path in $FILES; do
  if ! curl -fsSL "$REPO_RAW/$rel_path" -o "$STAGE_DIR/$rel_path"; then
    printf "[!] Error: Failed to download %s. Aborting without modifying existing installation.\n" "$rel_path" >&2
    exit 1
  fi
  if [ ! -s "$STAGE_DIR/$rel_path" ]; then
    printf "[!] Error: Downloaded file %s is empty. Aborting without modifying existing installation.\n" "$rel_path" >&2
    exit 1
  fi
done

install_to_dir() {
  TARGET_DIR="${1%/}"
  PARENT_DIR="$(dirname "$TARGET_DIR")"

  if [ -e "$TARGET_DIR" ] && [ ! -d "$TARGET_DIR" ]; then
    printf "[!] Error: Target path %s exists and is not a directory. Aborting.\n" "$TARGET_DIR" >&2
    exit 1
  fi

  mkdir -p "$PARENT_DIR"

  # Case 1: Target directory already exists and is non-empty
  if [ -d "$TARGET_DIR" ] && [ -n "$(ls -A "$TARGET_DIR" 2>/dev/null)" ]; then
    if [ ! -f "$TARGET_DIR/SKILL.md" ]; then
      printf "[!] Error: Target directory %s is non-empty and does not appear to be a mckee-story-engine installation (missing SKILL.md). Refusing to overwrite.\n" "$TARGET_DIR" >&2
      exit 1
    fi

    # If existing installation is already identical to staged files, do not delete or touch it
    if diff -rq "$STAGE_DIR" "$TARGET_DIR" >/dev/null 2>&1; then
      printf "✓ mckee-story-engine at %s is already up to date\n" "$TARGET_DIR"
      return 0
    fi

    # Stage new directory on the same filesystem as TARGET_DIR
    TMP_NEW="${TARGET_DIR}.new.$$"
    ACTIVE_TMP_NEW="$TMP_NEW"
    rm -rf "$TMP_NEW"
    cp -R "$STAGE_DIR" "$TMP_NEW"

    BACKUP_DIR="${TARGET_DIR}.bak.$(date +%Y%m%d_%H%M%S).$$"
    ACTIVE_TARGET="$TARGET_DIR"
    ACTIVE_BACKUP="$BACKUP_DIR"

    # Move existing installation aside without deleting it
    if ! mv "$TARGET_DIR" "$BACKUP_DIR"; then
      ACTIVE_TARGET=""
      ACTIVE_BACKUP=""
      rm -rf "$TMP_NEW"
      ACTIVE_TMP_NEW=""
      printf "[!] Error: Failed to move existing installation %s to backup %s.\n" "$TARGET_DIR" "$BACKUP_DIR" >&2
      exit 1
    fi

    # Move staged directory into target location; if this fails or is interrupted, cleanup/recovery restores BACKUP_DIR
    if ! "$MV_CMD" "$TMP_NEW" "$TARGET_DIR"; then
      printf "[!] Error: Failed to activate new installation at %s; restoring previous version...\n" "$TARGET_DIR" >&2
      mv "$BACKUP_DIR" "$TARGET_DIR"
      ACTIVE_TARGET=""
      ACTIVE_BACKUP=""
      rm -rf "$TMP_NEW"
      ACTIVE_TMP_NEW=""
      exit 1
    fi

    ACTIVE_TARGET=""
    ACTIVE_BACKUP=""
    ACTIVE_TMP_NEW=""

    if [ "${MCKEE_FORCE_UPDATE:-0}" = "1" ]; then
      rm -rf "$BACKUP_DIR"
    else
      printf "[!] Notice: Existing files in %s differed from release; backed up previous version to %s\n" "$TARGET_DIR" "$BACKUP_DIR"
    fi

    printf "✓ Updated mckee-story-engine at %s\n" "$TARGET_DIR"
    return 0
  fi

  # Case 2: Target directory does not exist or is empty
  if [ -d "$TARGET_DIR" ]; then
    rmdir "$TARGET_DIR"
  fi

  TMP_NEW="${TARGET_DIR}.new.$$"
  rm -rf "$TMP_NEW"
  cp -R "$STAGE_DIR" "$TMP_NEW"
  if ! "$MV_CMD" "$TMP_NEW" "$TARGET_DIR"; then
    rm -rf "$TMP_NEW"
    printf "[!] Error: Failed to move staged installation to %s.\n" "$TARGET_DIR" >&2
    exit 1
  fi
  printf "✓ Installed mckee-story-engine to %s\n" "$TARGET_DIR"
}

if [ -n "$MCKEE_INSTALL_DIR" ]; then
  install_to_dir "$MCKEE_INSTALL_DIR"
else
  # 1. Install to ~/.claude/skills (Claude Code global skills)
  CLAUDE_DIR="$HOME/.claude/skills/mckee-story-engine"
  install_to_dir "$CLAUDE_DIR"

  # 2. If inside a workspace with .agent/skills, install there as well
  if [ -d ".agent" ]; then
    AGY_DIR=".agent/skills/mckee-story-engine"
    install_to_dir "$AGY_DIR"
  fi
fi

echo "Done! You can now use [DEEP TEARDOWN], [STORYNOMICS], [ARCHITECT], [SCRIPT DOCTOR], and [ACTION & PACING DOCTOR] modes."
