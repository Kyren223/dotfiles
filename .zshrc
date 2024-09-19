# Fix for tmux on openSuse with WSL2
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

# # Setup hooks for VIMODE in zsh
# function zle-keymap-select {
# if [[ ${KEYMAP} == vicmd ]]; then
#     export VIMODE="NORMAL"
#     echo -ne '\e[2 q'
# else
#     export VIMODE="INSERT"
#     echo -ne '\e[6 q'
# fi
# }
#
# function zle-line-init {
# export VIMODE="INSERT"
# echo -ne '\e[6 q'
# }
#
# function zle-line-finish {
# export VIMODE="INSERT"
# echo -ne '\e[6 q'
# }
#
# zle -N zle-keymap-select
# zle -N zle-line-init
# zle -N zle-line-finish

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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls $realpath'

# Load Homebrew
zinit ice wait lucid atload' eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
zinit load zdharma-continuum/null

# Shell integrations
zinit ice wait lucid atload'eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/tokyocat_laptop.omp.yml)"'
zinit load zdharma-continuum/null

zinit ice wait'!' nocd lucid atload'_omp_precmd'
zinit load zdharma-continuum/null

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

alias ivm='vim'
alias dc='cd'

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gP='git pull'
alias gl='git log --oneline -n 10'
alias gd='git diff'

# Exports
export PATH="$HOMEBREW_PREFIX/opt/ncurses/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export EDITOR=nvim
export PAGER=nvimpager
export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Open tmux if it's not open
if [ -z "$TMUX" ]; then
    tmux
fi

