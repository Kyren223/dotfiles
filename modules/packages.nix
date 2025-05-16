{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    glib-networking
    openssl
    clang
    clang-tools
    ghostty
    glibcLocales

    nerd-fonts.jetbrains-mono
    keepassxc
    git
    gh
    delta
    stow
    eza
    oh-my-posh
    gcc
    gnumake
    neovim
    fzf
    zoxide
    tmux
    bc
    keychain
    bat
    sqlite
    fd
    ripgrep
    wakatime-cli
    fastfetch
    btop
    protonvpn-gui
    unzip
    go
    pnpm
    nodejs_24
    (python312.withPackages (pypkgs: [
      pypkgs.matplotlib
      pypkgs.pandas
      pypkgs.pygithub
    ]))
    watchexec
    golangci-lint
    libnotify
    wl-clipboard
    whatsie
    libratbag # Mouse software (GHUB replacement)
    piper
    goose
    sqlc
    jetbrains.idea-community
    jdk
    maven
    gradle
    kdePackages.filelight
    kotlin
    (minecraft.overrideAttrs (finalAttrs: previousAttrs: {
      meta.lib.broken = false;
    }))
    rustup
    tokei
    kdePackages.kmines # Minesweeper for fun lol
    kdePackages.kpat # Solitaire
    # btw missing the card/brick thing with weird symbols, not sure what that game was called
    gimp
    kdePackages.korganizer
    kdePackages.kaddressbook
    gitleaks
    rar
    gomodifytags
    sops
    dig
    syncthingtray
    libreoffice
    vesktop
    nasm
    albert
    gdb
    minisign
    libisoburn
    ncdu
    imagemagick
    ghostscript # for imagemagick to support pdf files
    xxd
    gnome-clocks
    duf
    tldr
    bottom
    hyperfine
    nh
    wget
    mold
    aseprite
    prismlauncher
    cloudflare-warp
    drawio
    tree-sitter
    tectonic
    mermaid-cli
    ffmpeg
    haruna
    gparted
    r2modman
    openrgb-with-all-plugins

    # LSP
    asm-lsp
    astro-language-server
    basedpyright
    bash-language-server
    vscode-langservers-extracted # html/css/json
    gopls
    lemminx
    lua-language-server
    markdown-oxide
    marksman
    mdx-language-server
    neocmakelsp
    nil
    tailwindcss-language-server
    taplo
    typescript-language-server
    yaml-language-server
    # pnpm i -g css-variables-language-server
    # pnpm install -g gh-actions-language-server

    # Tools
    stylua
    gofumpt
    golangci-lint
    prettierd
    jq
    lldb # codelldb debugger
    shellcheck
    beautysh # shell formatter
  ];

}
