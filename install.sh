#!/bin/sh
# install.sh — Layan Cyber Oh My Posh Theme Installer
# POSIX-compliant. Installs layan-cyber theme for bash, zsh, fish, pwsh, and nu.
set -eu

VERSION="1.3.0"
REPO_RAW_BASE="https://raw.githubusercontent.com/LoneVertex/layan-cyber-posh/main"

# Safe fallback for HOME when unset under set -u
USER_HOME="${HOME:-}"
if [ -z "${USER_HOME}" ]; then
  USER_HOME="$(getent passwd "$(id -un 2>/dev/null || echo root)" 2>/dev/null | cut -d: -f6 || true)"
  if [ -z "${USER_HOME}" ]; then
    USER_HOME="/root"
  fi
fi

DEFAULT_DIR="${USER_HOME}/.config/oh-my-posh/themes"
THEME_BASE="layan-cyber.omp"
PRIMARY_THEME_FILE="${THEME_BASE}.toml"
ALL_FORMATS="toml json yaml"

show_help() {
  cat << EOH
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
EOH
}

# ── argument parsing ─────────────────────────────────────────────────────────

INSTALL_DIR="${DEFAULT_DIR}"
DO_UNINSTALL=0
POSITIONAL_COUNT=0

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
        echo "Error: --dir requires a non-empty directory path" >&2
        exit 1
      fi
      ;;
    -*)
      echo "Unknown option: $1" >&2
      echo "Use --help for usage information." >&2
      exit 1
      ;;
    *)
      if [ -z "$1" ]; then
        echo "Error: Destination directory cannot be empty." >&2
        exit 1
      fi
      if [ "${POSITIONAL_COUNT}" -ge 1 ]; then
        echo "Error: Unexpected argument '$1'. Only one destination directory may be specified." >&2
        exit 1
      fi
      INSTALL_DIR="$1"
      POSITIONAL_COUNT=$((POSITIONAL_COUNT + 1))
      shift
      ;;
  esac
done

if [ -z "${INSTALL_DIR}" ]; then
  echo "Error: Installation directory cannot be empty." >&2
  exit 1
fi

DEST="${INSTALL_DIR}/${PRIMARY_THEME_FILE}"

# ── uninstall handling ───────────────────────────────────────────────────────

if [ "${DO_UNINSTALL}" -eq 1 ]; then
  echo "🗑  Uninstalling layan-cyber theme from ${INSTALL_DIR}…"
  rm -f "${INSTALL_DIR}/${THEME_BASE}.toml" \
        "${INSTALL_DIR}/${THEME_BASE}.json" \
        "${INSTALL_DIR}/${THEME_BASE}.yaml"
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

resolve_script_path() {
  TARGET="$1"
  while [ -h "${TARGET}" ]; do
    LINK=$(ls -ld -- "${TARGET}" 2>/dev/null) || break
    LINK_TARGET=$(expr "${LINK}" : '.*-> \(.*\)$') || break
    case "${LINK_TARGET}" in
      /*) TARGET="${LINK_TARGET}" ;;
      *)  TARGET="$(dirname "${TARGET}")/${LINK_TARGET}" ;;
    esac
  done
  printf '%s\n' "${TARGET}"
}

SCRIPT_DIR=""
case "${0:-}" in
  */*)
    REAL_SCRIPT=$(resolve_script_path "$0")
    if [ -f "${REAL_SCRIPT}" ]; then
      RESOLVED_DIR=$(cd "$(dirname "${REAL_SCRIPT}")" 2>/dev/null && pwd)
      if [ -n "${RESOLVED_DIR}" ]; then
        SCRIPT_DIR="${RESOLVED_DIR}"
      fi
    fi
    ;;
esac

LOCAL_PRIMARY="${SCRIPT_DIR}/themes/${PRIMARY_THEME_FILE}"

if [ -n "${SCRIPT_DIR}" ] && [ -f "${LOCAL_PRIMARY}" ]; then
  echo "📂 Installing from local repository: ${SCRIPT_DIR}…"
  for ext in ${ALL_FORMATS}; do
    src_file="${SCRIPT_DIR}/themes/${THEME_BASE}.${ext}"
    if [ -f "${src_file}" ]; then
      cp -f "${src_file}" "${INSTALL_DIR}/"
    fi
  done
else
  echo "⬇  Downloading layan-cyber theme (all formats) from GitHub…"
  DOWNLOADER=""
  if command -v curl >/dev/null 2>&1; then
    DOWNLOADER="curl"
  elif command -v wget >/dev/null 2>&1; then
    DOWNLOADER="wget"
  else
    echo "✗  Neither curl nor wget found. Cannot download theme." >&2
    exit 1
  fi

  for ext in ${ALL_FORMATS}; do
    file_name="${THEME_BASE}.${ext}"
    target_dest="${INSTALL_DIR}/${file_name}"
    tmp_dest="${target_dest}.tmp.$$"
    theme_url="${REPO_RAW_BASE}/themes/${file_name}"

    if [ "${DOWNLOADER}" = "curl" ]; then
      if ! curl -fsSL --connect-timeout 10 --max-time 60 --retry 3 --retry-delay 1 "${theme_url}" -o "${tmp_dest}"; then
        echo "✗  Failed to download ${file_name} from ${theme_url}" >&2
        rm -f "${tmp_dest}"
        exit 1
      fi
    elif [ "${DOWNLOADER}" = "wget" ]; then
      if ! wget -q --timeout=15 --tries=3 --waitretry=1 -O "${tmp_dest}" "${theme_url}"; then
        echo "✗  Failed to download ${file_name} from ${theme_url}" >&2
        rm -f "${tmp_dest}"
        exit 1
      fi
    fi

    if [ ! -s "${tmp_dest}" ]; then
      echo "✗  Downloaded file ${file_name} is empty or corrupted." >&2
      rm -f "${tmp_dest}"
      exit 1
    fi

    mv -f "${tmp_dest}" "${target_dest}"
  done
fi

echo "✔  Theme installed to: ${DEST}"

# ── shell integration hints ──────────────────────────────────────────────────

echo ""
echo "── Add to your shell config ────────────────────────────────────────────"
echo ""
echo "  Bash   (~/.bashrc):"
# shellcheck disable=SC2016
  printf '  eval "$(oh-my-posh init bash --config "%s")"\n' "${DEST}"
echo ""
echo "  Zsh    (~/.zshrc):"
# shellcheck disable=SC2016
  printf '  eval "$(oh-my-posh init zsh --config "%s")"\n' "${DEST}"
echo ""
echo "  Fish   (~/.config/fish/config.fish):"
printf '  oh-my-posh init fish --config "%s" | source\n' "${DEST}"
echo ""
echo "  PowerShell (~/.config/powershell/Microsoft.PowerShell_profile.ps1):"
printf '  oh-my-posh init pwsh --config "%s" | Invoke-Expression\n' "${DEST}"
echo ""
echo "  Nushell (config.nu / env.nu):"
# shellcheck disable=SC2016
  printf '  # In ~/.config/nushell/config.nu (or $nu.config-path):\n'
printf '  oh-my-posh init nu --config "%s" --print | save -f ~/.cache/oh-my-posh/init.nu\n' "${DEST}"
printf '  source ~/.cache/oh-my-posh/init.nu\n'
echo ""
echo "── Reload your current shell session to activate layan-cyber ─────────────"
