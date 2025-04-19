{ config, pkgs, ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
}
