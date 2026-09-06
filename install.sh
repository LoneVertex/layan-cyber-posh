#!/bin/sh
# install.sh — Layan Cyber Oh My Posh Theme Installer
# POSIX-compliant. Installs layan-cyber theme for bash, zsh, fish, and pwsh.
set -eu

VERSION="1.2.0"
REPO_RAW_BASE="https://raw.githubusercontent.com/LoneVertex/layan-cyber-posh/main"
DEFAULT_DIR="${HOME}/.config/oh-my-posh/themes"
THEME_FILE="layan-cyber.omp.toml"

show_help() {
  cat << EOF
layan-cyber theme installer (v${VERSION})
Usage: install.sh [OPTIONS] [DESTINATION_DIR]

Options:
  -h, --help       Show this help message and exit
  -u, --uninstall  Remove installed layan-cyber theme files
  -d, --dir DIR    Specify installation directory (default: ~/.config/oh-my-posh/themes)

Examples:
  # Default installation to ~/.config/oh-my-posh/themes
  ./install.sh

  # Install to custom directory
  ./install.sh /custom/path

  # One-line remote installation
  curl -fsSL ${REPO_RAW_BASE}/install.sh | sh

  # Uninstall
  ./install.sh --uninstall
EOF
}

# ── argument parsing ─────────────────────────────────────────────────────────

INSTALL_DIR="${DEFAULT_DIR}"
DO_UNINSTALL=0

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      show_help
      exit 0
      ;;
    -u|--uninstall)
      DO_UNINSTALL=1
      shift
      ;;
    -d|--dir)
      if [ -n "${2:-}" ]; then
        INSTALL_DIR="$2"
        shift 2
      else
        echo "Error: --dir requires a directory path" >&2
        exit 1
      fi
      ;;
    -*)
      echo "Unknown option: $1" >&2
      echo "Use --help for usage information." >&2
      exit 1
      ;;
    *)
      INSTALL_DIR="$1"
      shift
      ;;
  esac
done

DEST="${INSTALL_DIR}/${THEME_FILE}"

# ── uninstall handling ───────────────────────────────────────────────────────

if [ "${DO_UNINSTALL}" -eq 1 ]; then
  echo "🗑  Uninstalling layan-cyber theme from ${INSTALL_DIR}…"
  rm -f "${INSTALL_DIR}/layan-cyber.omp.toml" \
        "${INSTALL_DIR}/layan-cyber.omp.json" \
        "${INSTALL_DIR}/layan-cyber.omp.yaml"
  echo "✔  Uninstallation complete."
  exit 0
fi

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

mkdir -p "${INSTALL_DIR}"

# ── source resolution (local clone vs remote download) ───────────────────────

SCRIPT_DIR=""
if [ -n "${0:-}" ] && [ -f "$0" ]; then
  SCRIPT_DIR=$(cd "$(dirname "$0")" 2>/dev/null && pwd || true)
fi

LOCAL_THEME="${SCRIPT_DIR}/themes/${THEME_FILE}"

if [ -n "${SCRIPT_DIR}" ] && [ -f "${LOCAL_THEME}" ]; then
  echo "📂 Installing from local repository: ${SCRIPT_DIR}…"
  cp -f "${SCRIPT_DIR}/themes/layan-cyber.omp."* "${INSTALL_DIR}/"
else
  echo "⬇  Downloading layan-cyber theme from GitHub…"
  THEME_URL="${REPO_RAW_BASE}/themes/${THEME_FILE}"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "${THEME_URL}" -o "${DEST}"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "${DEST}" "${THEME_URL}"
  else
    echo "✗  Neither curl nor wget found. Cannot download theme." >&2
    exit 1
  fi
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
