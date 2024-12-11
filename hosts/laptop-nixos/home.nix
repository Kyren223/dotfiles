{ config, pkgs, ... }:

{
  home.username = "kyren";
  home.homeDirectory = "/home/kyren";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    keepassxc
    discord
    git
    gh
    delta
    nh
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
    nvimpager
    go
    pnpm
    nodejs_23
    (python312.withPackages (pypkgs: [
      pypkgs.matplotlib
      pypkgs.pandas
    ]))
    watchexec
    golangci-lint
    libnotify
    wl-clipboard
    whatsie
    libratbag
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
    graphviz
    kdePackages.kmines # Minesweeper for fun lol
    kdePackages.kpat # Solitaire 
    # btw missing the card/brick thing with weird symbols, not sure what that game was called
    gimp
  ];

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
