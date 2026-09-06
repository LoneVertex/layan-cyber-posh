# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
