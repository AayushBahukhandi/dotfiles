# ~/.zshrc — Aayush Bahukhandi (AayushBahukhandi)
# Based on mehd-io/dotfiles, customized for personal workflow.

# --- powerlevel10k instant prompt (only loads if cache exists) ---
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Ghostty: auto-attach to tmux ---
# Attaches to most-recent session, or creates "main" if none exist.
if [[ -n "$GHOSTTY_RESOURCES_DIR" && -z "$TMUX" && -z "$SSH_TTY" && -z "$GHOSTTY_NO_TMUX" ]]; then
  if command -v tmux >/dev/null; then
    if tmux has-session 2>/dev/null; then
      exec tmux attach
    else
      exec tmux new-session -s main
    fi
  fi
fi

# --- oh-my-zsh (plugins only; starship is the prompt) ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- completion ---
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# --- starship prompt ---
eval "$(starship init zsh)"

# --- atuin shell history ---
eval "$(atuin init zsh)"

# --- zoxide (smart cd: z, zi) ---
eval "$(zoxide init zsh)"

# --- mise (polyglot runtime manager) ---
eval "$(mise activate zsh)"

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="/Applications/Cursor.app/Contents/Resources/app/bin:$PATH"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# --- opencode ---
export PATH="$HOME/.opencode/bin:$PATH"
alias oc='opencode'
alias oc-sonnet='opencode --model openrouter/anthropic/claude-sonnet-4.6'
alias oc-gpt5='opencode --model openrouter/openai/gpt-5-nano'

# --- pnpm ---
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- lmstudio ---
export PATH="$PATH:$HOME/.lmstudio/bin"

# --- antigravity ---
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# --- Kiro shell integration ---
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# --- duckman: DuckDB version manager (if installed) ---
command -v duckman >/dev/null && eval "$(duckman completion zsh)"

# --- aliases ---
alias vi="nvim"
alias v="nvim"
alias c="cursor"
alias zd="zed"
alias cc="claude"
alias g="git"
alias gs="git status"
alias gp="git push"

# Notes vault (Obsidian, iCloud-synced)
alias note='cd "$HOME/Library/Mobile Documents/com~apple~CloudDocs/aayush_notes" && nvim .'

# Personal project shortcuts
alias spotify='cd $HOME/Developer/spotify-bot/spoticord && cargo run'
alias home='cd ~/Developer/expense-ai && docker run --rm -v expenseowl:/data -v $(pwd):/app -w /app node:20 node addExpense.js'
alias personal='cd ~/Developer/expense-ai && docker run --rm -v expenseowl2:/data -v $(pwd):/app -w /app node:20 node addExpense.js'
alias homechat='cd ~/Developer/expense-ai && docker run -it --rm -e OLLAMA_URL=http://host.docker.internal:11434/api/generate -v expenseowl:/data -v $(pwd):/app -w /app node:20 node chatExpense.js'
alias personalchat='cd ~/Developer/expense-ai && docker run -it --rm -e OLLAMA_URL=http://host.docker.internal:11434/api/generate -v expenseowl2:/data -v $(pwd):/app -w /app node:20 node chatExpense.js'

# --- functions ---

# Quick jump to git repos in ~/Developer with fzf (Ctrl+G)
repo() {
  local dir
  dir=$(find ~/Developer -mindepth 1 -maxdepth 2 -type d 2>/dev/null | fzf --prompt="repo> ")
  [ -n "$dir" ] && cd "$dir"
}
bindkey -s '^g' 'repo\n'

# AI agent memory helpers
remember() {
  (cd "$HOME/Developer/ai-agent" && npm run memory -- remember "$*")
}
memories() {
  (cd "$HOME/Developer/ai-agent" && npm run memory -- memories "$*")
}

# Convert any CSV file to Parquet via DuckDB
csv_to_parquet() {
  local f="$1"
  duckdb -c "COPY (SELECT * FROM read_csv_auto('$f')) TO '${f%.*}.parquet' (FORMAT PARQUET);"
}

# AWS profile switcher
aws-profile-ls() { cat ~/.aws/credentials | grep "\[" | sed 's/\(^.\)\(.*\)\(.$\)/\2/g'; }
aws-profile-switch() {
  grep -q -w "\[profile ${1}\]" ~/.aws/config || { echo "No such profile $1"; return 1; }
  export AWS_PROFILE="$1"
  echo "AWS profile $1 configured"
}
alias apl=aws-profile-ls
alias aps=aws-profile-switch

# --- git account switcher (load only if file exists) ---
[ -f "$HOME/.git-acc" ] && source "$HOME/.git-acc"

# --- pokemon banner on shell start (uncomment if you want it) ---
# command -v krabby >/dev/null && krabby random

# --- machine-local additions (gitignored) ---
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
