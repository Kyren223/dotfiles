{ ... }: {

  imports = [
    ./hardware-configuration-laptop.nix
    ./configuration.nix
    ../modules/laptop.nix
  ];

  networking.hostName = "kyren-laptop";

  development.enable = true;

}
