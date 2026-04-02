---
name: pngzip
description: Batch-compress PNG files with pngquant from directories or explicit file paths. Use when the user wants to optimize PNG assets, shrink image size, process multiple PNGs at once, or install and use the pngzip CLI/skill workflow.
---

# pngzip

Use this skill when the user wants to compress PNG images from the terminal, reduce PNG asset sizes in a project, or set up the `pngzip` command locally.

## What This Skill Does

- Compresses all PNG files inside one or more directories
- Compresses one or more explicit PNG file paths
- Skips missing paths and non-PNG files without aborting the full run
- Supports global CLI installation through the bundled installer

## Workflow

1. Confirm whether the user wants:
   - one or more directories processed
   - one or more PNG files processed
   - the command installed globally
2. If the command is not installed and the user wants ongoing usage, run:

```bash
./scripts/install.sh
```

3. Execute the CLI with the requested paths:

```bash
./bin/pngzip ./assets
./bin/pngzip ./assets ./images/a.png ./images/b.png
```

4. Report:
   - which paths were processed
   - which paths were skipped
   - the summary from the CLI

## Bundled Resources

- CLI executable: `./bin/pngzip`
- CLI installer: `./scripts/install.sh`
- Skill installer: `./scripts/install-skill.sh`
- Smoke test: `./tests/test_pngzip.sh`

## Notes

- The CLI requires `pngquant`.
- Running `pngzip` without arguments prints help.
- Directory paths are scanned recursively for `.png` files.
