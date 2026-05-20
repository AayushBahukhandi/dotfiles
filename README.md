# dotfiles

> Aayush Bahukhandi's macOS development environment. Tested on Apple Silicon (M-series).

A productivity-focused, opinionated setup wrapped in [GNU Stow](https://www.gnu.org/software/stow/) for clean install/uninstall.

## Stack

| Tool | Role |
|---|---|
| [**Aerospace**](https://github.com/nikitabobko/AeroSpace) | i3-style tiling window manager (10 workspaces split across 2 monitors) |
| [**Sketchybar**](https://github.com/FelixKratz/SketchyBar) | Custom top status bar with per-monitor workspace indicators |
| [**Ghostty**](https://ghostty.org/) | Fast GPU-accelerated terminal — auto-attaches to tmux on launch |
| [**Zsh**](https://www.zsh.org/) + [**Starship**](https://starship.rs/) | Shell with Pastel Powerline prompt |
| [**Atuin**](https://docs.atuin.sh/) | Magical shell history with `Ctrl+R` fuzzy search |
| [**Tmux**](https://github.com/tmux/tmux) | Terminal multiplexer (`Ctrl+S` prefix, tmux-resurrect, tmux-continuum) |
| [**Neovim**](https://neovim.io/) + [**LazyVim**](https://www.lazyvim.org/) | Editor with custom config in `lua/aayush/` |
| [**Lazygit**](https://github.com/jesseduffield/lazygit) | TUI git client with commitizen integration |
| [**Hidden Bar**](https://github.com/dwarvesf/hidden) + [**Stats**](https://github.com/exelban/stats) | Menu bar utilities |
| [**Raycast**](https://www.raycast.com/) | Spotlight replacement (`Cmd+Space`) |
| [**OrbStack**](https://orbstack.dev/) | Fast Docker + Linux VMs |

Plus: bun, duckdb, ffmpeg, fd, ripgrep, fzf, yazi, gh, jq, neonctl, ollama, rclone, yt-dlp, and the usual cloud / media CLIs.

## Layout (GNU Stow format)

```
~/Developer/dotfiles/
├── README.md
├── install.sh           # Stow-based bootstrap with subcommand flags
├── Brewfile             # all CLIs + GUI casks
├── macos.sh             # macOS defaults (dock, finder, key repeat, etc.)
├── zsh/                 # ~/.zshrc, ~/.zprofile, ~/.zshenv
├── tmux/                # ~/.tmux.conf
├── ghostty/             # ~/.config/ghostty/config
├── starship/            # ~/.config/starship.toml
├── atuin/               # ~/.config/atuin/config.toml
├── aerospace/           # ~/.config/aerospace/aerospace.toml
├── sketchybar/          # ~/.config/sketchybar/
├── borders/             # ~/.config/borders/bordersrc
├── nvim/                # ~/.config/nvim/   (LazyVim + lua/aayush/ custom)
├── lazygit/             # ~/.config/lazygit/config.yml
└── scripts/             # tmux helper scripts (pane-info, log-pane, etc.)
```

Each subdirectory is a **Stow package**. Running `stow zsh` symlinks every file under `dotfiles/zsh/` into the matching path in `$HOME`.

## Prerequisites

- macOS (Apple Silicon recommended)
- [Homebrew](https://brew.sh/) — `install.sh` will install if missing
- Xcode Command Line Tools — `xcode-select --install`
- [GNU Stow](https://www.gnu.org/software/stow/) — `install.sh` installs via Homebrew
- A [Nerd Font](https://www.nerdfonts.com/) (Hack Nerd Font installed via Brewfile)

## Install

```bash
git clone https://github.com/AayushBahukhandi/dotfiles ~/Developer/dotfiles
cd ~/Developer/dotfiles
./install.sh                # full install
```

### Subcommands

```bash
./install.sh --apps          # only run brew bundle (CLIs + casks)
./install.sh --defaults      # only macOS defaults (macos.sh)
./install.sh --stow          # only symlink dotfiles via Stow
./install.sh --unstow        # remove dotfile symlinks (does NOT delete files)
./install.sh --nvim          # pre-build tree-sitter parsers
./install.sh --sketchybar    # install sketchybar font + restart service
./install.sh --aerospace     # launch Aerospace
./install.sh --help
```

The Stow step **backs up any existing real files** in `~/dotfiles-backup-YYYYMMDD-HHMMSS/` before symlinking — safe to run on a machine that already has configs.

## Post-install

1. **Restart your terminal** (or open a fresh Ghostty window) to pick up `.zshrc`.
2. **Log out and back in** so Aerospace, Sketchybar, and the menu-bar autohide fully activate.
3. **`atuin login`** to enable shell history sync.
4. **First `nvim` launch** auto-installs Lazy plugins (~60-90s).
5. **`:Copilot setup`** inside nvim if you want GitHub Copilot.
6. **Grant Aerospace Accessibility permission**: System Settings → Privacy & Security → Accessibility → toggle ON for AeroSpace.

## Customization

### Machine-local additions

Anything you don't want to commit lives in two gitignored files:

- `~/.zshrc.local` — sourced at the end of `.zshrc` (per-machine aliases, secrets, paths)
- `~/.zprofile.local` — sourced at the end of `.zprofile` (per-machine login env)

Create them by hand on each machine; the public dotfiles never reference machine-specific paths.

### Workspaces (Aerospace)

Edit `aerospace/.config/aerospace/aerospace.toml`:

```toml
[workspace-to-monitor-force-assignment]
1 = 'main'       # main monitor workspaces
…
6 = 'secondary'  # secondary monitor workspaces
```

10 workspaces total: `alt+1..9` and `alt+0` (= workspace 10). To add an 11th, mirror the pattern in the `[mode.main.binding]` and `[workspace-to-monitor-force-assignment]` blocks.

### Sketchybar layout

Live in `sketchybar/.config/sketchybar/`:

- `sketchybarrc` — bar items + workspace-to-monitor mapping
- `plugins/` — per-item shell scripts (battery, volume, clock, aerospace)
- `items/front_app.sh` — center "active app" indicator
- `icon_map_fn.sh` — app icon mapping for workspace labels

Reload with `sketchybar --reload` or `alt+shift+r`.

### Neovim config

LazyVim base + craftzdog-style additions under `nvim/.config/nvim/lua/aayush/`:

- `discipline.lua` — disables h/j/k/l spam (forces motion practice)
- `hsl.lua` — HSL color helpers
- `lsp.lua` — LSP overrides

Plugin files in `lua/plugins/` (`coding.lua`, `editor.lua`, `lsp.lua`, `treesitter.lua`, `ui.lua`).

## Uninstall

```bash
cd ~/Developer/dotfiles
./install.sh --unstow             # remove all symlinks
brew bundle cleanup --file=Brewfile --force   # uninstall brew packages
```

macOS defaults set by `macos.sh` aren't reversible by Stow; restore from a Time Machine backup or `defaults import` from a pre-install snapshot.

## Credits

This setup stands on the shoulders of two excellent dotfile repos:

- [**mehd-io/dotfiles**](https://github.com/mehd-io/dotfiles) — the structure for zsh/tmux/aerospace/sketchybar/ghostty configs, plus the `install.sh` design pattern.
- [**craftzdog/dotfiles-public**](https://github.com/craftzdog/dotfiles-public) — the Neovim LazyVim config and lazygit setup (`commitizen` keybind).

Customized, de-personalized, and adapted by [@AayushBahukhandi](https://github.com/AayushBahukhandi).

## License

MIT — do whatever you want.
