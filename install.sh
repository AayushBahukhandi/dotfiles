#!/usr/bin/env bash
# install.sh — set up Aayush's dotfiles via GNU Stow.
# Idempotent. Run any subset via flags.
#
# Usage:
#   ./install.sh                  full install (apps + defaults + stow + nvim parsers)
#   ./install.sh --full           same as no args
#   ./install.sh --apps           brew bundle from Brewfile
#   ./install.sh --defaults       macOS defaults (runs macos.sh)
#   ./install.sh --stow           symlink dotfiles via GNU Stow
#   ./install.sh --unstow         remove symlinks (does NOT delete files)
#   ./install.sh --nvim           pre-build treesitter parsers
#   ./install.sh --sketchybar     symlink config + install app-icon font + restart service
#   ./install.sh --aerospace      symlink + start aerospace
#   ./install.sh --help

set -euo pipefail

DOTFILES="${DOTFILES:-$HOME/Developer/dotfiles}"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# Stow packages to deploy (top-level dirs in this repo, in Stow format)
PACKAGES=(zsh tmux ghostty starship atuin aerospace sketchybar borders nvim lazygit)

# --- helpers --------------------------------------------------------------

C_BLUE="\033[1;34m"; C_GREEN="\033[1;32m"; C_YELLOW="\033[1;33m"; C_RED="\033[1;31m"; C_RESET="\033[0m"
info()  { printf "${C_BLUE}>>> %s${C_RESET}\n" "$*"; }
ok()    { printf "${C_GREEN}✓ %s${C_RESET}\n" "$*"; }
warn()  { printf "${C_YELLOW}⚠ %s${C_RESET}\n" "$*"; }
err()   { printf "${C_RED}✗ %s${C_RESET}\n" "$*" >&2; }

ensure_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

ensure_stow() {
  ensure_brew
  if ! command -v stow >/dev/null 2>&1; then
    info "Installing GNU Stow"
    brew install stow
  fi
}

backup_conflicts() {
  # Move any real files that would collide with stow into the backup dir.
  # Skip symlinks (stow will replace those cleanly with --restow).
  mkdir -p "$BACKUP_DIR"
  local moved=0
  for pkg in "${PACKAGES[@]}"; do
    [ -d "$DOTFILES/$pkg" ] || continue
    while IFS= read -r src; do
      local rel="${src#$DOTFILES/$pkg/}"
      local target="$HOME/$rel"
      if [ -e "$target" ] && [ ! -L "$target" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
        mv "$target" "$BACKUP_DIR/$rel"
        moved=$((moved + 1))
      fi
    done < <(find "$DOTFILES/$pkg" -type f -not -path '*/.git/*')
  done
  if [ "$moved" -gt 0 ]; then
    ok "Backed up $moved conflicting file(s) to $BACKUP_DIR"
  else
    rmdir "$BACKUP_DIR" 2>/dev/null || true
  fi
}

# --- subcommands ----------------------------------------------------------

install_apps() {
  info "Installing Homebrew packages"
  ensure_brew
  brew bundle --file="$DOTFILES/Brewfile" || {
    warn "brew bundle had failures (likely sudo-required casks)."
    warn "Re-run 'brew bundle --file=$DOTFILES/Brewfile' from a real terminal so it can prompt for sudo."
  }
}

install_defaults() {
  info "Applying macOS defaults"
  bash "$DOTFILES/macos.sh"
}

install_stow() {
  info "Symlinking via GNU Stow"
  ensure_stow
  backup_conflicts
  cd "$DOTFILES"
  for pkg in "${PACKAGES[@]}"; do
    if [ -d "$pkg" ]; then
      stow --restow --target="$HOME" "$pkg"
      ok "stowed $pkg"
    fi
  done
  # Default shell
  if [ "$SHELL" != "/bin/zsh" ]; then
    chsh -s /bin/zsh || true
  fi
}

uninstall_stow() {
  info "Removing dotfile symlinks"
  ensure_stow
  cd "$DOTFILES"
  for pkg in "${PACKAGES[@]}"; do
    if [ -d "$pkg" ]; then
      stow --delete --target="$HOME" "$pkg" 2>/dev/null && ok "unstowed $pkg" || warn "skip $pkg"
    fi
  done
}

install_nvim() {
  info "Bootstrapping Neovim (Lazy + treesitter parsers)"
  if ! command -v tree-sitter >/dev/null 2>&1; then
    npm install -g tree-sitter-cli || warn "tree-sitter-cli install failed; parsers may not build"
  fi
  nvim --headless "+Lazy! sync" "+qa" 2>/dev/null || true
  nvim --headless "+TSUpdate" "+sleep 30" "+qa" 2>/dev/null || true
  ok "Neovim bootstrap kicked off"
}

install_sketchybar() {
  info "Configuring Sketchybar"
  ensure_brew
  if ! brew list --formula 2>/dev/null | grep -q sketchybar; then
    brew install felixkratz/formulae/sketchybar
  fi
  local font_version="v2.0.51"
  curl -sL -o /tmp/sketchybar-app-font.ttf \
    "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/${font_version}/sketchybar-app-font.ttf"
  mkdir -p "$HOME/Library/Fonts"
  cp /tmp/sketchybar-app-font.ttf "$HOME/Library/Fonts/sketchybar-app-font.ttf"
  rm -f /tmp/sketchybar-app-font.ttf
  brew services restart sketchybar || true
  ok "Sketchybar installed and restarted"
}

install_aerospace() {
  info "Configuring Aerospace"
  if [ ! -d "/Applications/AeroSpace.app" ]; then
    brew install --cask nikitabobko/tap/aerospace
  fi
  open -a AeroSpace || true
  ok "Aerospace launched (grant Accessibility in System Settings on first run)"
}

install_full() {
  install_apps
  install_defaults
  install_stow
  install_nvim
  install_sketchybar
  install_aerospace

  echo
  ok "Install complete."
  echo
  echo "Next steps:"
  echo "  1. Restart your terminal (or open a fresh Ghostty)."
  echo "  2. Log out and back in to fully activate Aerospace + macOS defaults."
  echo "  3. atuin login       # sync shell history across machines"
  echo "  4. nvim → Lazy installs plugins automatically; first launch takes ~1 min."
  if [ -d "$BACKUP_DIR" ]; then
    echo "  5. Previous configs backed up at: $BACKUP_DIR"
  fi
}

print_usage() {
  sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'
}

# --- main -----------------------------------------------------------------

case "${1:-}" in
  ""|--full)        install_full ;;
  --apps)           install_apps ;;
  --defaults)       install_defaults ;;
  --stow)           install_stow ;;
  --unstow)         uninstall_stow ;;
  --nvim)           install_nvim ;;
  --sketchybar)     install_sketchybar ;;
  --aerospace)      install_aerospace ;;
  --help|-h)        print_usage ;;
  *) err "Unknown flag: $1"; print_usage; exit 1 ;;
esac
