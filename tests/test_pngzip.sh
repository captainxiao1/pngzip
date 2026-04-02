#!/bin/zsh

set -euo pipefail

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
SCRIPT="$ROOT_DIR/bin/pngzip"
CLI_INSTALL_SCRIPT="$ROOT_DIR/scripts/install.sh"
SKILL_INSTALL_SCRIPT="$ROOT_DIR/scripts/install-skill.sh"
TEST_TMPDIR=$(mktemp -d)
trap 'rm -rf "$TEST_TMPDIR"' EXIT

assert_contains() {
  local haystack="$1"
  local needle="$2"

  if [[ "$haystack" != *"$needle"* ]]; then
    echo "Expected output to contain: $needle"
    echo "Actual output:"
    echo "$haystack"
    exit 1
  fi
}

assert_file_exists() {
  local path="$1"

  if [[ ! -f "$path" ]]; then
    echo "Expected file to exist: $path"
    exit 1
  fi
}

assert_symlink_target() {
  local path="$1"
  local expected="$2"
  local actual

  actual=$(/usr/bin/readlink "$path")
  if [[ "$actual" != "$expected" ]]; then
    echo "Expected symlink $path -> $expected"
    echo "Actual symlink target: $actual"
    exit 1
  fi
}

FAKE_BIN="$TEST_TMPDIR/bin"
mkdir -p "$FAKE_BIN"

cat > "$FAKE_BIN/pngquant" <<'EOF'
#!/bin/zsh
set -euo pipefail

output=""
input=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)
      output="$2"
      shift 2
      ;;
    --)
      input="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

if [[ -z "$output" || -z "$input" ]]; then
  exit 1
fi

printf 'tiny' > "$output"
EOF
chmod +x "$FAKE_BIN/pngquant"

export PATH="$FAKE_BIN:$PATH"

help_output=$("$SCRIPT" --help)
assert_contains "$help_output" "Usage:"
assert_contains "$help_output" "pngzip"

default_output=$("$SCRIPT")
assert_contains "$default_output" "Usage:"
assert_contains "$default_output" "pngzip"

mkdir -p "$TEST_TMPDIR/images"
printf 'this-is-a-png-placeholder' > "$TEST_TMPDIR/images/a.png"
printf 'this-is-a-png-placeholder-2' > "$TEST_TMPDIR/images/b.PNG"
printf 'ignore-me' > "$TEST_TMPDIR/images/readme.txt"
mkdir -p "$TEST_TMPDIR/more"
printf 'third-file-content' > "$TEST_TMPDIR/more/c.png"
printf 'plain-text' > "$TEST_TMPDIR/not-png.txt"

compress_output=$("$SCRIPT" "$TEST_TMPDIR/images" "$TEST_TMPDIR/more/c.png" "$TEST_TMPDIR/not-png.txt" "$TEST_TMPDIR/not-found")
assert_contains "$compress_output" "PNG Batch Compression"
assert_contains "$compress_output" "a.png"
assert_contains "$compress_output" "b.PNG"
assert_contains "$compress_output" "c.png"
assert_contains "$compress_output" "Non-PNG file"
assert_contains "$compress_output" "Path does not exist"
assert_contains "$compress_output" "Processed files: 3"
assert_contains "$compress_output" "Compressed files: 3"

INSTALL_HOME="$TEST_TMPDIR/install-home"
mkdir -p "$INSTALL_HOME"
install_output=$(
  HOME="$INSTALL_HOME" \
  "$CLI_INSTALL_SCRIPT"
)

assert_contains "$install_output" "Installation complete"
assert_contains "$install_output" "pngzip"
assert_file_exists "$INSTALL_HOME/.local/bin/pngzip"

installed_help=$(
  HOME="$INSTALL_HOME" \
  PATH="$INSTALL_HOME/.local/bin:$FAKE_BIN:$PATH" \
  pngzip --help
)
assert_contains "$installed_help" "pngzip"

login_shell_help=$(
  HOME="$INSTALL_HOME" \
  PATH="$FAKE_BIN:$PATH" \
  zsh -lc 'command -v pngzip && pngzip --help'
)
assert_contains "$login_shell_help" "pngzip"

skill_install_output=$(
  HOME="$INSTALL_HOME" \
  "$SKILL_INSTALL_SCRIPT"
)
assert_contains "$skill_install_output" "Skill installation complete"
assert_contains "$skill_install_output" "SKILL.md"
assert_file_exists "$ROOT_DIR/SKILL.md"
assert_file_exists "$ROOT_DIR/agents/openai.yaml"
assert_symlink_target "$INSTALL_HOME/.codex/skills/pngzip" "$ROOT_DIR"

echo "All tests passed"
