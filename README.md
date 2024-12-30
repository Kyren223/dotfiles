# Dotfiles

My personal dotfiles for reproducing my entire machine.

Includes

- Operating System and packages (NixOS)
- Neovim config
- Ghostty Terminal config
- Tmux config
- Utility scripts

## Installation

Use your preferred package manager to install GNU stow

Then clone the repository

```sh
$ git clone https://github.com/kyren223/dotfiles
```

Let stow generate all the symlinks for you

```sh
$ cd ~/dotfiles && stow .
```

You may need to add the `--adopt` flag to stow to override existing your existing dotfiles.

If using NixOS, rebuild your system using the flake

```sh
$ sudo nixos-rebuild switch --flake ~/dotfiles#laptop-nixos
```
