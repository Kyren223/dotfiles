{ pkgs, inputs, ... }: {

  imports = [
    ./hardware-configuration-desktop.nix
    ../modules/common.nix
    ../modules/kde.nix
    ../modules/networking.nix
    inputs.home-manager.nixosModules.default
  ];

  networking.hostName = "kyren-desktop";

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users = {
      "kyren" = import ./home.nix;
    };
  };
}
