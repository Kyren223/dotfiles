# Start measuring time
typeset -F SECONDS=0

# Install catppuccin automatically if it's not installed already
if [[ ! -d "$HOME/.config/tmux/plugins/catppuccin" ]]; then
  mkdir -p $HOME/.config/tmux/plugins/catppuccin
  git clone -b v2.1.2 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
fi

# pnpm
export PNPM_HOME="/home/kyren/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Install zinit if missing
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
fi

# Load Zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

autoload -Uz compinit
compinit

# Zsh plugins
zinit ice wait lucid && zinit light zsh-users/zsh-syntax-highlighting
zinit ice wait lucid && zinit light zsh-users/zsh-completions
zinit ice wait lucid && zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions

# Styling for fzf-tab completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls $realpath'

# Load oh my posh
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/tokyocat.omp.yml)"

# Shell integrations
zinit ice wait lucid atload'source <(fzf --zsh)' && zinit load zdharma-continuum/null
zinit ice wait lucid atload'eval "$(zoxide init --cmd cd zsh)"' && zinit load zdharma-continuum/null
zinit ice wait lucid atload'source <(k completion zsh)' && zinit load zdharma-continuum/null

# Fzf
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS=" \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
source $HOME/scripts/fzf-git.sh

# # Keybindings
bindkey -v # Vim Mode
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey "^y" autosuggest-accept

# History
HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Misc Aliases
alias ls='eza --group-directories-first --across --icons auto'
alias tree='eza --tree --icons'
alias c='clear'
alias vim='nvim'

# K aliases
alias ks='k switch'
alias kn='k new'

# Git Aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gP='git pull'
alias gl='git log'
alias glo='git log --oneline'
alias gb='git branch'

# Env vars
export EDITOR=nvim
export PAGER=less
export MANPAGER=$PAGER

# Stop wine from spamming debug
export WINEDEBUG=-all

# Path
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/scripts"
export PATH="$PATH:$HOME/.zig"
export PATH="$PATH:$HOME/.zls"
export PATH="$PATH:$HOME/projects/k/bin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# Start ssh-agent if not running
# export SSH_ASKPASS_REQUIRE="prefer"
eval $(keychain --quiet --quick --lockwait 60 --eval ~/.ssh/id_ed25519)

MARKER_FILE="/run/user/$(id -u)/autorun_once_marker"
if [ ! -f "$MARKER_FILE" ]; then
  touch "$MARKER_FILE"
  K_SWITCH_HOME=
fi

if [ -v K_SWITCH_HOME ]; then
  k switch $HOME
fi

if true; then
  printf "\e[38;5;34m⚡ \e[38;5;220m.zshrc parsed in \e[38;5;33m%.0fms\e[0m\n" "$(( SECONDS * 1000 ))"
fi
