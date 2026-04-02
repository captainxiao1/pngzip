#!/bin/zsh

set -euo pipefail

readonly COMMAND_NAME="pngzip"
readonly INSTALL_DIR="${HOME}/.local/bin"
readonly TARGET_PATH="${INSTALL_DIR}/${COMMAND_NAME}"
readonly SOURCE_PATH="$(cd "$(dirname "$0")/.." && pwd)/bin/pngzip"
readonly PATH_EXPORT='export PATH="$HOME/.local/bin:$PATH"'

ensure_path_in_file() {
  local file="$1"

  touch "$file"
  if ! grep -F "$PATH_EXPORT" "$file" >/dev/null 2>&1; then
    printf '\n%s\n' "$PATH_EXPORT" >> "$file"
  fi
}

mkdir -p "$INSTALL_DIR"
cp "$SOURCE_PATH" "$TARGET_PATH"
chmod +x "$TARGET_PATH"
ensure_path_in_file "${HOME}/.zshrc"
ensure_path_in_file "${HOME}/.zprofile"

echo "Installation complete: $TARGET_PATH"
echo "Command: $COMMAND_NAME"
echo "PATH entry was added to ~/.zshrc and ~/.zprofile"
