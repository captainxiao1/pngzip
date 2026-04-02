#!/bin/zsh

set -euo pipefail

readonly SKILL_NAME="pngzip"
readonly SOURCE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
readonly SKILLS_DIR="${HOME}/.codex/skills"
readonly TARGET_PATH="${SKILLS_DIR}/${SKILL_NAME}"

mkdir -p "$SKILLS_DIR"
rm -f "$TARGET_PATH"
ln -s "$SOURCE_DIR" "$TARGET_PATH"

echo "Skill installation complete: $TARGET_PATH"
echo "Skill name: $SKILL_NAME"
echo "Entry file: $SOURCE_DIR/SKILL.md"
