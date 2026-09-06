# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
