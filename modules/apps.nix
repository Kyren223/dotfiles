{
  pkgs,
  lib,
  config,
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

      nerd-fonts.jetbrains-mono

      pipeline # Youtube desktop app

      # Utility
      protonvpn-gui
      cloudflare-warp

      kdePackages.korganizer
      kdePackages.kaddressbook

      syncthingtray

      gnome-clocks

      spotify
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
