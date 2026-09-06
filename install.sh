#!/usr/bin/env sh
set -e

THEME_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-posh/themes"
RAW_BASE_URL="https://raw.githubusercontent.com/LoneVertex/layan-cyber-posh/main/themes"

printf "\033[1;36m==> Installing layan-cyber Oh My Posh theme...\033[0m\n"
mkdir -p "$THEME_DIR"

SCRIPT_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd || echo "")"

if [ -f "$SCRIPT_DIR/themes/layan-cyber.omp.toml" ]; then
    printf "Copying local theme files to %s...\n" "$THEME_DIR"
    cp -f "$SCRIPT_DIR"/themes/layan-cyber.omp.* "$THEME_DIR/"
else
    printf "Downloading theme files to %s...\n" "$THEME_DIR"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$RAW_BASE_URL/layan-cyber.omp.toml" -o "$THEME_DIR/layan-cyber.omp.toml"
        curl -fsSL "$RAW_BASE_URL/layan-cyber.omp.json" -o "$THEME_DIR/layan-cyber.omp.json"
        curl -fsSL "$RAW_BASE_URL/layan-cyber.omp.yaml" -o "$THEME_DIR/layan-cyber.omp.yaml"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$RAW_BASE_URL/layan-cyber.omp.toml" -O "$THEME_DIR/layan-cyber.omp.toml"
        wget -q "$RAW_BASE_URL/layan-cyber.omp.json" -O "$THEME_DIR/layan-cyber.omp.json"
        wget -q "$RAW_BASE_URL/layan-cyber.omp.yaml" -O "$THEME_DIR/layan-cyber.omp.yaml"
    else
        printf "\033[1;31mError: curl or wget is required to download theme files.\033[0m\n" >&2
        exit 1
    fi
fi

printf "\033[1;32m==> Successfully installed layan-cyber to %s!\033[0m\n\n" "$THEME_DIR"
printf "Add one of the following lines to your shell configuration:\n\n"
printf "\033[1;33mBash (~/.bashrc):\033[0m\n"
printf '  eval "$(oh-my-posh init bash --config %s/layan-cyber.omp.toml)"\n\n' "$THEME_DIR"
printf "\033[1;33mZsh (~/.zshrc):\033[0m\n"
printf '  eval "$(oh-my-posh init zsh --config %s/layan-cyber.omp.toml)"\n\n' "$THEME_DIR"
printf "\033[1;33mFish (~/.config/fish/config.fish):\033[0m\n"
printf '  oh-my-posh init fish --config %s/layan-cyber.omp.toml | source\n\n' "$THEME_DIR"
printf "\033[1;33mPowerShell ($PROFILE):\033[0m\n"
printf '  oh-my-posh init pwsh --config "%s/layan-cyber.omp.toml" | Invoke-Expression\n\n' "$THEME_DIR"
