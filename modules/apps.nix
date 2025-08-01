{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{

  options.apps.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "enables apps";
  };

  config = lib.mkIf config.apps.enable {

    programs.firefox.enable = true;

    programs.kdeconnect.enable = true; # Opens TCP/UDP ports (does not when it's a pkg)

    environment.systemPackages = with pkgs; [
      # System
      glib-networking
      openssl
      glibcLocales
      libnotify
      wl-clipboard
      jdk
      noto-fonts

      dejavu_fonts
      font-awesome
      material-design-icons

      libratbag # Mouse software (GHUB replacement)
      piper # ^ GUI frontend

      # Utility
      obs-studio
      gimp
      inkscape
      keepassxc
      protonvpn-gui
      (python312.withPackages (pypkgs: [
        pypkgs.matplotlib
        pypkgs.pandas
        pypkgs.pygithub
        pypkgs.pipx
      ]))
      kdePackages.filelight
      kdePackages.korganizer
      kdePackages.kaddressbook
      syncthingtray
      libreoffice
      albert
      goldendict-ng # for albert dictionary feature
      aseprite
      cloudflare-warp
      haruna
      gparted
      gnome-clocks
      inputs.zen-browser.packages."${system}".twilight
      chromium # for firefox/zen issue not rendering emojis properly

      # Communication
      wasistlos # Whatsapp
      vesktop
      inputs.eko.packages."${system}".eko

      # Terminal
      ghostty
      nerd-fonts.jetbrains-mono
      oh-my-posh
      tmux
      neovim
      tree-sitter

      # CLI
      git
      delta
      gh
      stow
      eza
      keychain
      bc
      bat
      fd
      ripgrep
      wakatime-cli
      fastfetch
      btop
      sqlite
      unzip
      fzf
      zoxide
      watchexec
      gitleaks
      rar
      dig
      minisign
      libisoburn
      dua
      mprocs
      imagemagick
      ghostscript # for imagemagick to support pdf files
      xxd
      duf
      tldr
      bottom
      hyperfine # for benchmarking
      wget
      tectonic
      mermaid-cli
      ffmpeg
      nh
      kondo # Cleans build caches
      kopia
      kopia-ui
      appimage-run
    ];

    # VPN for Vault Hunters to avoid connection issues
    # Note, will break discord, also tried proton VPN, still has conn issues
    services.cloudflare-warp.enable = true;

    # Mouse config service (used with piper)
    services.ratbagd.enable = true;

    # Install Docker (without using root access)
    #virtualisation.docker.enable = true;
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };

  };
}
