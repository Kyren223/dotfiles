{ config, pkgs, inputs, ... }: {

  imports = [
    ./hardware-configuration-laptop.nix
    ../modules/common.nix
    ../modules/kde.nix
    ../modules/networking.nix
    ../modules/laptop.nix
    inputs.home-manager.nixosModules.default
  ];

  networking.hostName = "kyren-laptop";

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users = {
      "kyren" = import ./home.nix;
    };
  };
}
