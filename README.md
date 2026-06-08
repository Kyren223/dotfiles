# Dotfiles

My personal dotfiles for reproducing my setup.

Includes

- System Packages (via my own custom config tool)
- Neovim config
- Ghostty Terminal config
- Tmux config
- Utility scripts

## Installation

Install GNU stow via your package manager and clone the repository:

```sh
git clone https://git.kyren.codes/kyren223/dotfiles
```

Let stow generate all the symlinks for you by running:

```sh
cd ~/dotfiles && stow .
```

You may need to add the `--adopt` flag to override your existing configs.

To install all system packages configured in `k config` run:

```sh
k sync
```
