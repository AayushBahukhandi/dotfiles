# ~/.zprofile — login-time shell init
# Runs once per login session, before .zshrc

# --- Homebrew (must come first; sets PATH for everything else) ---
eval "$(/opt/homebrew/bin/brew shellenv)"

# --- OrbStack (Docker / Linux VMs) ---
[ -f "$HOME/.orbstack/shell/init.zsh" ] && source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null

# --- Obsidian CLI ---
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"

# --- Python 3.13 framework ---
if [ -d "/Library/Frameworks/Python.framework/Versions/3.13/bin" ]; then
  PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:${PATH}"
  export PATH
fi

# --- ssh-agent ---
if [ -z "$SSH_AUTH_SOCK" ]; then
  RUNNING_AGENT=$(ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]')
  if [ "$RUNNING_AGENT" = "0" ]; then
    ssh-agent -s &> "$HOME/.ssh/ssh-agent"
  fi
  [ -f "$HOME/.ssh/ssh-agent" ] && eval $(cat "$HOME/.ssh/ssh-agent") > /dev/null
fi

# --- aliases that should be available even in login shells ---
alias v="nvim"
alias cc="claude"

# --- machine-local additions (gitignored) ---
[ -f "$HOME/.zprofile.local" ] && source "$HOME/.zprofile.local"
