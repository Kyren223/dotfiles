# Fix for tmux on openSuse with WSL2
mkdir -p /tmp
export TMUX_TMPDIR='/tmp'

# Enable rustup tab completion for zsh - https://rust-lang.github.io/rustup/installation/index.html
rustup completions zsh > ~/.zfunc/_rustup
fpath+=~/.zfunc

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

# Zsh plugins
zinit ice wait lucid && zinit light zsh-users/zsh-syntax-highlighting
zinit ice wait lucid && zinit light zsh-users/zsh-completions
zinit ice wait lucid && zinit light Aloxaf/fzf-tab
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Zsh snippets
zinit ice wait lucid && zinit snippet OMZP::git
zinit ice wait lucid && zinit snippet OMZP::sudo
zinit ice wait lucid && zinit snippet OMZP::kubectl
zinit ice wait lucid && zinit snippet OMZP::kubectx
zinit ice wait lucid && zinit snippet OMZP::command-not-found

# Fat cursor
function zle-line-init {
    echo -ne '\e[2 q'
}
zle -N zle-line-init

# Keybindings
bindkey -v 
bindkey '^y' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
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

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls $realpath'

# Load oh my posh
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/tokyocat.omp.yml)"

# Shell integrations
zinit ice wait lucid atload"source <(fzf --zsh)"
zinit load zdharma-continuum/null
zinit ice wait lucid atload'eval "$(zoxide init --cmd cd zsh)"'
zinit load zdharma-continuum/null

# Aliases
alias nvim='nvim.sh'
alias cat='bat'
alias ls='eza'
alias lsv='eza -lah' # v for verbose
alias tree='eza --tree'
alias c='clear'
alias q='exit'
alias ':q'='exit'
alias vim='nvim'
alias sqlite3='sqlite3 --box'
alias gs='git status'
alias python='python3.12'
alias py='python'

alias ivm='vim'
alias dc='cd'

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# Exports
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export EDITOR=nvim
export PAGER=nvimpager
export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Open tmux if it's not open
if [ -z "$TMUX" ]; then
    tmux a || tmux
fi

# NOTE: if clipboard breaks try this:
# https://superuser.com/questions/1617298/wsl-2-running-ubuntu-x-server-cant-open-display#1618390
# setting display to:
# export DISPLAY=wsl:0.0
# Seems to fix it, but the post says it breaks some stuff (like firefox which I anyways run on windows)
# But just in case, the better way to do it seems to be:
# export DISPLAY=:0
# After more checking, it needs to be the wsl one, otherwise it doesn't work
# After more issues with both, I just disabled systemd again which seems to have issues
# with xclip and tmux and probably more issues I haven't noticed, and all I wanted is to use docker
# I am fine running the docker dameon manually if I need to use docker

