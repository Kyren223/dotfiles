{ pkgs, lib, config, ... }: {

  options.gaming.enable = lib.mkOption {
    type        = lib.types.bool;
    default     = false;
    description = "enables gaming";
  };

  config = lib.mkIf config.gaming.enable {

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    environment.systemPackages = with pkgs; [
      r2modman # For modded valheim
      prismlauncher # mc
      drawio # For VH

      (minecraft.overrideAttrs (finalAttrs: previousAttrs: {
        meta.lib.broken = false;
      }))

      kdePackages.kmines # Minesweeper for fun lol
      kdePackages.kpat # Solitaire
      # btw missing the card/brick thing with weird symbols, not sure what that game was called

      legendary-gl # Epic games launcher CLI
      heroic # GUI for legendary (and some other stores)
      wineWow64Packages.stagingFull # For non-steam games support, for GE-wine

      osu-lazer-bin
    ];

  };
}
