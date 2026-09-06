#!/bin/sh
# install.sh — Layan Cyber Oh My Posh Theme Installer
# POSIX-compliant. Installs theme for bash, zsh, fish, and pwsh.
set -eu

REPO_URL="https://raw.githubusercontent.com/LoneVertex/layan-cyber-posh/main/themes/layan-cyber.omp.toml"
DEFAULT_DIR="${HOME}/.config/oh-my-posh/themes"
THEME_FILE="layan-cyber.omp.toml"

# ── preflight ────────────────────────────────────────────────────────────────

if ! command -v oh-my-posh >/dev/null 2>&1; then
  echo "⚠  oh-my-posh not found in PATH." >&2
  echo "   Install it first: https://ohmyposh.dev/docs/installation/linux" >&2
  echo "   Then re-run this script." >&2
  exit 1
fi

OMP_VER=$(oh-my-posh version 2>/dev/null || echo "unknown")
echo "✔  oh-my-posh ${OMP_VER} detected."

# ── destination ──────────────────────────────────────────────────────────────

INSTALL_DIR="${1:-${DEFAULT_DIR}}"
mkdir -p "${INSTALL_DIR}"

DEST="${INSTALL_DIR}/${THEME_FILE}"

# ── download ─────────────────────────────────────────────────────────────────

echo "⬇  Downloading layan-cyber theme…"

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "${REPO_URL}" -o "${DEST}"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "${DEST}" "${REPO_URL}"
else
  echo "✗  Neither curl nor wget found. Cannot download theme." >&2
  exit 1
fi

echo "✔  Theme installed to: ${DEST}"

# ── shell integration hints ──────────────────────────────────────────────────

echo ""
echo "── Add to your shell config ────────────────────────────────────────────"
echo ""
echo "  Bash   (~/.bashrc):"
printf '  eval "$(oh-my-posh init bash --config \"%s\")"\n' "${DEST}"
echo ""
echo "  Zsh    (~/.zshrc):"
printf '  eval "$(oh-my-posh init zsh --config \"%s\")"\n' "${DEST}"
echo ""
echo "  Fish   (~/.config/fish/config.fish):"
printf '  oh-my-posh init fish --config "%s" | source\n' "${DEST}"
echo ""
echo "  PowerShell (~/.config/powershell/Microsoft.PowerShell_profile.ps1):"
printf '  oh-my-posh init pwsh --config "%s" | Invoke-Expression\n' "${DEST}"
echo ""
echo "── Reload your shell or run: source ~/.bashrc ───────────────────────────"
