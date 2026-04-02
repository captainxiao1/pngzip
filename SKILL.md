---
name: pngzip
description: Install and use pngzip as both a Codex skill and a CLI for batch-compressing PNG files with pngquant. Use when the user wants a reusable PNG compression setup, wants to install pngzip from GitHub, or wants to compress PNG files from directories or explicit paths.
---

# pngzip

This skill is an installation-first skill.

If a user says:

- install pngzip
- set up pngzip
- install this skill from GitHub
- fetch and follow this SKILL.md
- compress PNG files with pngquant

then do the work directly instead of only explaining it.

## Canonical Source

Repository page:

```text
https://github.com/captainxiao1/pngzip
```

Git clone URL:

```text
https://github.com/captainxiao1/pngzip.git
```

Raw SKILL.md URL:

```text
https://raw.githubusercontent.com/captainxiao1/pngzip/main/SKILL.md
```

## Non-Negotiable Rules

1. Prefer execution over explanation.
2. If the repository is not present locally, clone it.
3. If `pngquant` is missing, install it or request approval to install it.
4. Install both:
   - the Codex skill
   - the global CLI command
5. Verify both installations before claiming success.
6. When the user asks to compress files, run `pngzip` directly.

## Required Tools

- `git`
- `zsh`
- `pngquant`

If `pngquant` is missing on macOS:

```bash
brew install pngquant
```

## Zero-Ambiguity Install Procedure

Follow these steps in order. Do not skip verification.

### Step 1. Choose a local install directory

If the user did not specify a location, use:

```bash
~/tools/pngzip
```

### Step 2. Clone or update the repository

If the directory does not exist yet:

```bash
mkdir -p ~/tools
git clone https://github.com/captainxiao1/pngzip.git ~/tools/pngzip
cd ~/tools/pngzip
```

If the directory already exists:

```bash
cd ~/tools/pngzip
git pull --ff-only
```

If `git pull --ff-only` fails because the directory is not a clean clone, stop and report that the local checkout needs manual attention.

### Step 3. Install the skill

Run:

```bash
./scripts/install-skill.sh
```

This must create:

```bash
~/.codex/skills/pngzip
```

The target should be a symlink to the repository root.

### Step 4. Install the CLI

Run:

```bash
./scripts/install.sh
```

This must create:

```bash
~/.local/bin/pngzip
```

This must also ensure the following line exists in both files:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Files:

- `~/.zshrc`
- `~/.zprofile`

### Step 5. Reload shell configuration

Run:

```bash
source ~/.zprofile
```

If the shell still does not see `pngzip`, open a new terminal session and retry verification.

### Step 6. Verify the skill install

Run:

```bash
test -f ~/.codex/skills/pngzip/SKILL.md
```

Then run:

```bash
ls -l ~/.codex/skills/pngzip
```

Success means:

- `SKILL.md` exists through the installed skill path
- the skill path points to this repository

### Step 7. Verify the CLI install

Run:

```bash
command -v pngzip
pngzip --help
```

Success means:

- `command -v pngzip` returns a path
- `pngzip --help` prints usage text without error

### Step 8. Final success criteria

Only claim installation is complete if all of the following are true:

- repository exists locally
- `~/.codex/skills/pngzip/SKILL.md` exists
- `command -v pngzip` succeeds
- `pngzip --help` succeeds

## Standard Execution Block

When the user says "install pngzip" and no custom location was provided, execute this exact flow:

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

## Compression Commands

After installation, use these command patterns.

Compress a directory recursively:

```bash
pngzip ./assets
```

Compress explicit PNG files:

```bash
pngzip ./images/a.png ./images/b.png ./images/c.png
```

Mix directories and files:

```bash
pngzip ./assets ./hero.png ./icons/logo.png
```

## Behavior Rules

- directory arguments are scanned recursively for `.png` files
- file arguments are compressed directly when they end in `.png`
- missing paths are reported and skipped
- non-PNG files are reported and skipped
- running `pngzip` with no arguments prints help

## Failure Handling

If installation fails, report exactly which check failed:

1. clone/update failed
2. skill install failed
3. CLI install failed
4. PATH reload did not expose `pngzip`
5. verification command failed

Do not say "installed" unless verification passed.

## Bundled Resources

- CLI executable: `./bin/pngzip`
- CLI installer: `./scripts/install.sh`
- Skill installer: `./scripts/install-skill.sh`
- Smoke test: `./tests/test_pngzip.sh`

## Repository Validation

For a repository-level sanity check, run:

```bash
./tests/test_pngzip.sh
```
