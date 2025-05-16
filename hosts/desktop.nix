{ ... }: {

  imports = [
    ./hardware-configuration-desktop.nix
    ./configuration.nix
    ../modules/desktop.nix
  ];

  networking.hostName = "kyren-desktop";

  development.enable = true;
  gaming.enable = true;

}
