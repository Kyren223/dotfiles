{ pkgs, ... }: {

  imports = [
    ./nvidia.nix
  ];

  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
    phoronix-test-suite
  ];

}
