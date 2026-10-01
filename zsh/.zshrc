# ------------------------------------------------------------------------------
# History Configuration
# ------------------------------------------------------------------------------
# Keep a lot of history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# Share history across multiple terminal sessions
setopt SHARE_HISTORY
# Don't record exact duplicates in history
setopt HIST_IGNORE_ALL_DUPS

# ------------------------------------------------------------------------------
# Smart Up/Down Arrow History Search
# ------------------------------------------------------------------------------
# This searches for commands that start with the text you've already typed.
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Bind to Up/Down arrow keys
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# ------------------------------------------------------------------------------
# Plugins (macOS Homebrew or Linux system packages)
# ------------------------------------------------------------------------------
# Autosuggestions (Faded text predictions based on your history)
for _zsh_plugin in \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh; do
  if [[ -f "$_zsh_plugin" ]]; then
    source "$_zsh_plugin"
    break
  fi
done

# Syntax Highlighting (Green for valid, red for invalid - must be loaded last!)
for _zsh_plugin in \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
  if [[ -f "$_zsh_plugin" ]]; then
    source "$_zsh_plugin"
    break
  fi
done
unset _zsh_plugin

# ------------------------------------------------------------------------------
# Prompt (Starship)
# ------------------------------------------------------------------------------
# Initialize the Starship prompt if installed
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Agent Fleet (wt-fleet) shortcuts (Gemini CLI, Claude Code, OpenAI Codex)
alias wfm="wt-fleet mayor"
alias wfmc="wt-fleet mayor --cli claude"
alias wfmx="wt-fleet --cli codex mayor"
alias wfmg="wt-fleet mayor --cli gemini"
alias wfs="wt-fleet status"
alias wfi="wt-fleet inbox"

