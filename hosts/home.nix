{ pkgs, inputs, ... }: {

  home.username = "kyren";
  home.homeDirectory = "/home/kyren";

  home.stateVersion = "24.05"; # DO NOT CHANGE

  home.packages = with pkgs; [
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
    nodejs_23
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
    activitywatch
    awatcher
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
    jq

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
  ];

  # For nixd LSP to recognize what nixpkgs version I use
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".jdks/openjdk17".source = pkgs.openjdk17;
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  xdg.desktopEntries = {
    "com.ktechpit.whatsie" = {
      name = "WhatsApp";
      genericName = "Watsie, unofficial WhatsApp client";
      exec = "whatsie %U";
      terminal = false;
      icon = "com.github.eneshecan.WhatsAppForLinux";
      categories = [ "Application" "Network" "WebBrowser" ];
      settings = {
        Keywords = "chat;im;messaging;messenger;sms;whatsapp;whatsapp-desktop;whatsie;";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
