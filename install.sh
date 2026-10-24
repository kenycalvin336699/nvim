#!/usr/bin/env bash
# Installs the system packages this Neovim config uses, then (optionally) clones it.
# Works on: Termux, Arch, Debian/Ubuntu, Fedora.   Usage: ./install.sh
set -euo pipefail

REPO_URL="https://github.com/YOUR_USER/YOUR_REPO.git"   # <- change this
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

have() { command -v "$1" >/dev/null 2>&1; }
say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }

SUDO=""
if [ "$(id -u)" -ne 0 ] && have sudo; then SUDO="sudo"; fi

if [ -n "${TERMUX_VERSION:-}" ] || [[ "${PREFIX:-}" == *com.termux* ]]; then
  say "Termux detected"
  pkg update -y
  pkg install -y neovim git clang make ripgrep fd unzip curl nodejs python
  # optional extras; ignore the ones your Termux repo doesn't have
  for p in tree-sitter lazygit lua-language-server rust-analyzer; do
    pkg install -y "$p" || warn "package '$p' not available, skipping"
  done
  have npm && npm install -g vscode-langservers-extracted || warn "html/css language servers not installed"
elif have pacman; then
  say "Arch detected"
  $SUDO pacman -S --needed --noconfirm neovim git base-devel ripgrep fd unzip curl wget \
    nodejs npm python tree-sitter-cli lazygit
elif have apt-get; then
  say "Debian/Ubuntu detected"
  $SUDO apt-get update
  $SUDO apt-get install -y git build-essential ripgrep fd-find unzip curl wget nodejs npm python3
  if ! have nvim; then $SUDO apt-get install -y neovim; fi
  warn "apt's neovim is often older than 0.11. If 'nvim --version' is lower, install the latest from https://github.com/neovim/neovim/releases"
  have tree-sitter || { have npm && $SUDO npm install -g tree-sitter-cli || warn "tree-sitter CLI missing: parsers won't compile (highlighting still works for built-in languages)"; }
elif have dnf; then
  say "Fedora detected"
  $SUDO dnf install -y neovim git gcc make ripgrep fd-find unzip curl wget nodejs npm python3 tree-sitter-cli lazygit \
    || warn "some packages failed; the config still starts without them"
else
  warn "Unknown system. Install manually: neovim>=0.11, git, a C compiler, ripgrep, fd, unzip, curl, tree-sitter CLI."
fi

if [ ! -d "$CONFIG_DIR" ]; then
  say "Cloning config to $CONFIG_DIR"
  git clone "$REPO_URL" "$CONFIG_DIR"
elif [ -d "$CONFIG_DIR/.git" ]; then
  say "Config already present in $CONFIG_DIR"
else
  warn "$CONFIG_DIR exists and is not this repo. Move it away first: mv $CONFIG_DIR $CONFIG_DIR.bak"
  exit 1
fi

say "Installing plugins (first run takes a few minutes)"
nvim --headless "+Lazy! sync" +qa || warn "Plugin sync reported errors. Re-run: nvim --headless '+Lazy! sync' +qa"
say "Done. Start with: nvim"
