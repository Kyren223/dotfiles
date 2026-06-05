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
    programs.kdeconnect.enable = true; # Opens TCP/UDP ports (does not when it's a pkg)

    environment.systemPackages = with pkgs; [
      # System
      glib-networking
      openssl
      glibcLocales
      libnotify
      wl-clipboard
      jdk

      nerd-fonts.jetbrains-mono

      libratbag # Mouse software (GHUB replacement)
      piper # ^ GUI frontend

      # Utility
      protonvpn-gui
      (python312.withPackages (pypkgs: [
        pypkgs.matplotlib
        pypkgs.pandas
        pypkgs.pygithub
        pypkgs.pipx
      ]))
      kdePackages.korganizer
      kdePackages.kaddressbook
      syncthingtray
      cloudflare-warp
      gnome-clocks
      pipeline # Youtube desktop app
      kopia-ui
      rclone-ui
      binsider
      yt-dlp
      spotify
      inotify-tools
      _010editor
      warpd
      wl-kbptr
      nnd # Terminal debugger for linux
      cppcheck
      smartmontools # For ZFS monitoring apparently

      # Communication
      wasistlos # Whatsapp
      inputs.eko.packages."${system}".eko

      # Terminal
      tree-sitter

      # CLI
      wakatime-cli
      watchexec
      rar
      dig
      minisign
      libisoburn
      mprocs
      imagemagick
      ghostscript # for imagemagick to support pdf files
      xxd
      duf
      tldr
      bottom
      tectonic
      mermaid-cli
      kondo # Cleans build caches
      kopia
      rclone
      usbutils
    ];

    # VPN for Vault Hunters to avoid connection issues
    # Note, will break discord, also tried proton VPN, still has conn issues
    services.cloudflare-warp.enable = true;

    # Install Docker (without using root access)
    #virtualisation.docker.enable = true;
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
