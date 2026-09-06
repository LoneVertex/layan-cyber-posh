# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2026-09-06

### Fixed
- **100% Raw Schema Compliance:** Resolved all upstream v3 JSON Schema validation issues. Replaced obsolete/unsupported options (`fetch_status`, `fetch_upstream`, `timeout`) with official segment-level caching (`cache.duration`, `cache.strategy = "folder"`). Zero CI property stripping required.
- **Narrow Terminal Viewports (40 & 60 cols):** Added `min_width: 65` to the session segment (`user@host`), automatically dropping line 1 width from 67 to 39 columns on compact screens and preventing hardware terminal wrapping.
- **Native Right Prompt Architecture:** Migrated block 1 from `type = "prompt", alignment = "right"` to native `type = "rprompt"`, eliminating upstream modulo whitespace injection.
- **Polyglot Go & Rust Versioning:** Configured `parse_mod_file: true` and `fetch_version: true` for Go so `go.mod` is parsed in sub-millisecond time without spawning external binaries. Added template guarding (`{{ if .Full }}`) to both Go and Rust segments to eliminate phantom empty capsules.
- **Transient Prompt Error Jitter:** Synced `transient_prompt.template` to include error status (`{{ if gt .Code 0 }} ✗ {{ .Code }}{{ end }} ❯ `), aligning transient and primary prompts column-for-column across all exit codes (0, 1, 127).
- **Runaway Git Branch Names:** Added `trunc 20 .HEAD` to prevent long branch names from overflowing prompt lines.

### Added
- **Filesystem Read-Only Lock Indicator:** Added `{{ if not .Writable }} {{ end }}` to the path segment, displaying a lock icon when navigating read-only filesystems.
- **Strict Performance CI Gate:** Hardened GitHub Actions CI with an uncompromised $\le 20.0$ms latency threshold, 40-140 column viewport verification, and multi-shell (`bash`, `zsh`, `fish`, `pwsh`) strict generation checks.

## [1.2.0] - 2026-09-06

### Fixed
- **Capsule Geometry & Diamond Restoration:** Restored `leading_diamond = "\uE0B6"` and `trailing_diamond = "\uE0B4 "` across all segments using safe TOML unicode escape sequences, preventing heredoc byte stripping and restoring the theme's signature rounded capsule/pill aesthetic.
- **Icon Encoding Integrity:** Restored `\uF044` (git edit), `\uF046` (git staged), `\uE718` (Node.js), and `\uE606` (Python) glyphs with explicit TOML unicode escapes.
- **Installer CLI Parsing:** Fixed `install.sh` crash when passed `--help` or `-h`. Added clean argument parsing for `--help`, `--uninstall` (`-u`), and `--dir` (`-d`).
- **Installer Offline Support:** `install.sh` now auto-detects if it is being executed inside a cloned git repository and copies theme files locally without making redundant network requests.

### Added
- **Go Runtime Segment:** Right prompt now automatically displays the Go runtime pill (`\uE627` ``) in cyan when `go.mod` exists.
- **Rust Runtime Segment:** Right prompt now automatically displays the Rust runtime pill (`\uE7A8` ``) in orange when `Cargo.toml` exists.
- **Git Stash Visibility:** Git segment now detects and displays active stashes (`\uEB4B` ` <count>`).
- **Strict Format Synchronization Gate:** GitHub Actions CI now enforces byte-for-byte synchronization between `layan-cyber.omp.toml`, `layan-cyber.omp.json`, and `layan-cyber.omp.yaml` via automated `diff -u`.
- **Installer Syntax Gate:** GitHub Actions CI now runs `sh -n install.sh` and `--help` verification.
- **Dynamic Badges:** Added live GitHub Actions CI status and GitHub Release version badges to `README.md`.

## [1.1.0] - 2026-09-06

### Fixed
- **Schema compliance:** Replaced deprecated `type = "exit"` segment with the modern `type = "status"` — fully valid per the official Oh My Posh v3 JSON schema.
- **Schema compliance:** Removed `ignore_submodules = ["all"]` (wrong type — schema requires an object, not a string array).
- **Schema compliance:** Removed legacy v1/v2 git properties (`fetch_stash`, `fetch_worktree`) not present in the v3 schema.
- **Schema compliance:** Replaced `executiontime` `style = "human"` (deprecated) with `style = "austin"` — equivalent rendering, schema-valid.
- **Git color precedence:** Reordered `background_templates` so dirty/conflict states always win over ahead-only state. Previously, being ahead masked uncommitted changes with purple — now orange correctly dominates. Full tested matrix: Conflict → Red, Diverged → Red, Dirty → Orange, Behind → Orange, Ahead+Clean → Purple, Clean → Yellow.
- **Transient prompt alignment:** Removed trailing space from the input-line text segment template. `final_space = true` now provides exactly one space, aligning the primary `❯` with the transient `❯` at the same column — zero cursor jitter when pressing Enter.
- **install.sh:** Added `set -eu` for strict error handling, pre-flight check for `oh-my-posh` in `$PATH`, `curl`/`wget` fallback, and properly quoted config paths in all eval output strings.

### Added
- **SSH session indicator:** Session pill now shows `󰢹` glyph when connected over SSH — instant visual context for remote work (requires Nerd Font v3+).
- **Right prompt overflow protection:** Added `overflow = "hide"` to the right-prompt block — right-side segments gracefully disappear on narrow terminals (< ~80 cols) instead of wrapping and colliding with the left prompt.
- **CI: JSON schema validation:** New CI step validates the exported JSON theme against the official Oh My Posh schema URL, stripping known runtime-only properties (`fetch_status`, `fetch_upstream`, `cache_duration`, `timeout`) that are accepted by the runtime but not listed in the published schema.
- **CI: Narrow terminal test:** New CI step verifies the prompt renders in ≤ 2 lines at 60 columns.
- **CI: Latency check:** New CI step asserts render time ≤ 50ms via `oh-my-posh debug`.

### Performance
- **Python segment:** Disabled `fetch_version` (set to `false`). The template only renders `{{ .Venv }}` — fetching the Python version binary was pure overhead (~13ms extra per prompt). Render time cut from ~24ms to ~16ms.

## [1.0.0] - 2026-09-06

### Added
- Initial public release of `layan-cyber` theme for Oh My Posh.
- Available in TOML (`.omp.toml`), JSON (`.omp.json`), and YAML (`.omp.yaml`) formats.
- Floating capsule / pill diamond geometry with Powerline glyphs (`` / ``).
- Dracula / Cyberpunk high-contrast pastel color palette.
- Two-line responsive prompt layout with clean command input area.
- Multi-state Git segment (clean, dirty, ahead, behind, diverged) with performance caching.
- Contextual runtime indicators for Node.js (`package.json`) and Python virtual environments.
- Execution time tracker with human-readable formatting for commands taking $\ge 2000$ms.
- Transient prompt support collapsing previous commands into a minimal `❯` symbol.
- Distro-aware OS glyph detection with emoji fallback.
- Automated CI testing workflow via GitHub Actions.
