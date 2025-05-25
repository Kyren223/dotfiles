{ pkgs, ... }: {

  imports = [
    ./nvidia.nix
  ];

  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
    phoronix-test-suite
  ];

  # Fix "graphics reset" issue with nvidia GPU
  # See section 10 of https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks
  boot.extraModprobeConfig = ''
    options nvidia  NVreg_PreserveVideoMemoryAllocations=1
  '';
}
