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
  

  # Automaticaly mount C drive
  fileSystems."/mnt/c" = {
    device = "/dev/nvme1n1p4";
    fsType = "ntfs-3g";
    options = [ "rw" "noatime" "uid=1000" ];
  };

  # Automatically mount E drive
  fileSystems."/mnt/e" = {
    device = "/dev/sda2";
    fsType = "ntfs-3g";
    options = [ "rw" "noatime" "uid=1000" ];
  };

}
