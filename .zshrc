# Fix for tmux on openSuse with WSL2
export TMUX_TMPDIR='/tmp'

# Directory to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download zinit if it doesn't exist yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Zsh snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Enable rustup tab completion for zsh - https://rust-lang.github.io/rustup/installation/index.html
fpath+=~/.zfunc

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Setup hooks for VIMODE in zsh
function zle-keymap-select {
if [[ ${KEYMAP} == vicmd ]]; then
    export VIMODE="NORMAL"
    echo -ne '\e[2 q'
else
    export VIMODE="INSERT"
    echo -ne '\e[6 q'
fi
}

function zle-line-init {
export VIMODE="INSERT"
echo -ne '\e[6 q'
}

function zle-line-finish {
export VIMODE="INSERT"
echo -ne '\e[6 q'
}

zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish

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
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza $realpath'

# Load Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Shell integrations
source <(fzf --zsh)
eval "$(zoxide init --cmd cd zsh)"
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/tokyocat_laptop.omp.yml)"

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
alias python='python3'
alias vi='nvim $(fzf --preview="bat --style=numbers --color=always --line-range :500 {}")'

alias zshrc='vim ~/.zshrc && source ~/.zshrc'
alias tmuxconf='vim ~/.config/tmux/tmux.conf'
alias nvimconf='cd ~/.config/nvim && nvim'
alias vimrc='nvimconf'

alias ivm='vim'
alias dc='cd'

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'

# Exports
export PATH="$HOMEBREW_PREFIX/opt/ncurses/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export EDITOR=nvim
export PAGER=nvimpager
export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# For CS50x, can be remvoed later
export CC="clang"
export CFLAGS="-ferror-limit=1 -gdwarf-4 -ggdb3 -O0 -std=c11 -Wall -Werror -Wextra -Wno-gnu-folding-constant -Wno-sign-compare -Wno-unused-parameter -Wno-unused-variable -Wno-unused-but-set-variable -Wshadow"
export LDLIBS="-lcrypt -lcs50 -lm"

# Open tmux if it's not open
if [ -z "$TMUX" ]; then
    tmux
fi

