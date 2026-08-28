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
# Plugins (Installed via Homebrew)
# ------------------------------------------------------------------------------
# Autosuggestions (Faded text predictions based on your history)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax Highlighting (Green for valid, red for invalid - must be loaded last!)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ------------------------------------------------------------------------------
# Prompt (Starship)
# ------------------------------------------------------------------------------
# Initialize the Starship prompt
eval "$(starship init zsh)"
