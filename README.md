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

Clone the repository, then run:

```bash
./scripts/install.sh
```

The installer will:

- copy the executable to `~/.local/bin/pngzip`
- make it executable
- add `~/.local/bin` to both `~/.zshrc` and `~/.zprofile` if needed

Reload your shell after installation:

```bash
source ~/.zprofile
```

## Install As a Codex Skill

Install the repository as a local Codex skill:

```bash
./scripts/install-skill.sh
```

This creates a symlink at `~/.codex/skills/pngzip` pointing to this repository.

After that, the skill can be invoked as:

```text
$pngzip
```

Typical requests that should trigger the skill:

- "Compress all PNG assets in ./assets"
- "Optimize these PNG files"
- "Batch-compress PNG images with pngquant"
- "Install pngzip as a reusable skill"

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
6. Confirm `SKILL.md` and `agents/openai.yaml` match the repository purpose
7. Verify `./scripts/install-skill.sh`
8. Set repository metadata on GitHub

Recommended GitHub metadata:

- Repository name: `pngzip`
- Description: `Batch-compress PNG files from the command line using pngquant.`
- Topics: `png`, `pngquant`, `cli`, `shell`, `zsh`, `image-optimization`

## License

MIT
