# pngzip

`pngzip` is a lightweight `zsh` command-line utility for batch-compressing PNG images with `pngquant`.

It is designed for fast local workflows where you want to optimize one file, many files, or entire folders from the terminal.

This repository also works as a Codex skill package, so you can install it as a reusable `pngzip` skill in addition to using the CLI directly.

## Features

- Compress PNG files recursively inside a directory
- Compress one or many PNG files directly
- Mix directories and files in the same command
- Skip missing paths and non-PNG files without aborting the full job
- Print a concise compression summary
- Install globally as `pngzip`

## Requirements

- `zsh`
- `pngquant`
- macOS or another Unix-like environment

Install `pngquant` with Homebrew:

```bash
brew install pngquant
```

## Installation

This repository is designed to be installed in two ways at the same time:

- as a Codex skill
- as a global CLI command

Default local repository path:

```bash
~/tools/pngzip
```

### Step 1. Clone or update the repository

If you do not have the repository locally yet:

```bash
mkdir -p ~/tools
git clone https://github.com/captainxiao1/pngzip.git ~/tools/pngzip
cd ~/tools/pngzip
```

If you already have it:

```bash
cd ~/tools/pngzip
git pull --ff-only
```

### Step 2. Install the Codex skill

```bash
./scripts/install-skill.sh
```

This creates:

```bash
~/.codex/skills/pngzip
```

### Step 3. Install the CLI

```bash
./scripts/install.sh
```

This creates:

```bash
~/.local/bin/pngzip
```

It also ensures this line exists in both `~/.zshrc` and `~/.zprofile`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Step 4. Reload shell config

```bash
source ~/.zprofile
```

### Step 5. Verify installation

```bash
test -f ~/.codex/skills/pngzip/SKILL.md
command -v pngzip
pngzip --help
```

Only treat installation as complete if all three commands succeed.

After installation, the skill can be invoked as:

```text
$pngzip
```

## Simple Tutorial

### Option 1. Install it manually

```bash
mkdir -p ~/tools
git clone https://github.com/captainxiao1/pngzip.git ~/tools/pngzip
cd ~/tools/pngzip
./scripts/install-skill.sh
./scripts/install.sh
source ~/.zprofile
pngzip --help
```

### Option 2. Let Claude Code install it

Copy this prompt into Claude Code:

```text
Fetch and follow https://raw.githubusercontent.com/captainxiao1/pngzip/main/SKILL.md
```

If you want a more explicit version, use:

```text
Read and follow this file exactly:
https://raw.githubusercontent.com/captainxiao1/pngzip/main/SKILL.md

Clone the repository to ~/tools/pngzip, install the skill, install the CLI, and verify that command -v pngzip and pngzip --help both succeed.
```

### Option 3. Compress PNG files right away

After installation:

```bash
pngzip ./assets
pngzip ./images/a.png ./images/b.png
pngzip ./assets ./hero.png ./icons/logo.png
```

## One-Line Skill Install Prompt

If you want another AI agent to install this skill directly, you can give it a prompt in this style:

```text
Fetch and follow https://raw.githubusercontent.com/captainxiao1/pngzip/main/SKILL.md
```

Example:

```text
Fetch and follow https://raw.githubusercontent.com/captainxiao1/pngzip/main/SKILL.md
```

You can also give the agent a slightly more explicit instruction:

```text
Fetch and follow https://raw.githubusercontent.com/captainxiao1/pngzip/main/SKILL.md, then install and use the pngzip skill.
```

For agents that work better with an explicit execution target, use:

```text
Fetch and follow https://raw.githubusercontent.com/captainxiao1/pngzip/main/SKILL.md, clone the repository to ~/tools/pngzip, install both the skill and the CLI, then verify command -v pngzip and pngzip --help.
```

## Usage

Show help:

```bash
pngzip --help
```

Compress a directory recursively:

```bash
pngzip ./assets
```

Compress multiple PNG files:

```bash
pngzip ./images/a.png ./images/b.png ./images/c.png
```

Mix directories and files:

```bash
pngzip ./assets ./hero.png ./icons/logo.png
```

## Standard Install Block

If you want a single copy-paste command sequence for a terminal:

```bash
mkdir -p ~/tools
if [ -d ~/tools/pngzip/.git ]; then
  cd ~/tools/pngzip && git pull --ff-only
else
  git clone https://github.com/captainxiao1/pngzip.git ~/tools/pngzip && cd ~/tools/pngzip
fi
./scripts/install-skill.sh
./scripts/install.sh
source ~/.zprofile
test -f ~/.codex/skills/pngzip/SKILL.md
command -v pngzip
pngzip --help
```

## Behavior

- Directory arguments are scanned recursively for `.png` files
- File arguments are compressed directly when they end in `.png`
- Missing paths are reported and skipped
- Non-PNG files are reported and skipped
- Running `pngzip` with no arguments prints help

## Example Output

```text
PNG Batch Compression
Command: pngzip
Input paths: ./assets ./hero.png
  ✓ icon.png  Saved 12.41KB
  ✓ hero.png  Saved 48.12KB
Done
Processed files: 2
Compressed files: 2
Skipped files: 0
Total saved: 60.53KB
```

## Project Structure

```text
.
├── SKILL.md
├── agents/openai.yaml
├── bin/pngzip
├── scripts/install.sh
├── scripts/install-skill.sh
├── tests/test_pngzip.sh
├── README.md
├── LICENSE
└── .gitignore
```

## Development

Run the smoke test:

```bash
tests/test_pngzip.sh
```

The test covers:

- help output
- no-argument behavior
- mixed directory and file inputs
- invalid path handling
- install flow
- login shell command visibility

## GitHub Release Preparation

Before publishing this repository:

1. Run `tests/test_pngzip.sh`
2. Check `bin/pngzip --help`
3. Verify `./scripts/install.sh` on a clean shell
4. Review the examples in `README.md`
5. Confirm `git status` is clean
6. Confirm `SKILL.md` and `README.md` describe the same install flow
7. Confirm `SKILL.md` and `agents/openai.yaml` match the repository purpose
8. Verify `./scripts/install-skill.sh`
9. Set repository metadata on GitHub

Recommended GitHub metadata:

- Repository name: `pngzip`
- Description: `Batch-compress PNG files from the command line using pngquant.`
- Topics: `png`, `pngquant`, `cli`, `shell`, `zsh`, `image-optimization`

## License

MIT
