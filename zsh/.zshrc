# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Powerlevel10k instant prompt (disabled: was leaving fd 2 pointing at /dev/null)
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
# Dropped: z (superseded by zoxide below), fzf (~/.fzf.zsh sets up the same
# bindings on line ~31), history (just an `h` alias — not worth a plugin).
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-autocomplete
  sudo
  macos
  colored-man-pages
)

source $ZSH/oh-my-zsh.sh

# ── fzf ──────────────────────────────────────────────────
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always {}'"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ── zoxide (smart cd) ─────────────────────────────────────
eval "$(zoxide init zsh)"

# ── Better ls / cat ───────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --git --group-directories-first'
alias lt='eza --tree --icons --level=2'
alias cat='bat --paging=never'

# ── Übersicht reload (FSEvents misses symlinked widget edits ~20% of the time) ──
alias ubr='osascript -e "tell application \"Übersicht\" to refresh"'

# ── History ───────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# ── Autosuggestion style ──────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#888888,italic"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ── p10k config ───────────────────────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="$HOME/.local/bin:$PATH"

# ── Aria VRS viewer ───────────────────────────────────────
alias play-vrs='/opt/homebrew/bin/python3.11 ~/.local/bin/preview_vrs.py'
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/michaelr808/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
