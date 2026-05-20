{ pkgs, ... }: {

  imports = [
    # ./nvidia.nix
  ];

  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
    phoronix-test-suite
  ];

  # Automaticaly mount C drive
  fileSystems."/mnt/c" = {
    device = "/dev/nvme1n1p4";
    fsType = "ntfs-3g";
    options = [ "rw" "noatime" "uid=1000" "nofail" ];
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "7223ffff";

  # Automatically mount E drive
  # fileSystems."/mnt/e" = {
  #   device = "/dev/sda2";
  #   fsType = "ntfs-3g";
  #   options = [ "rw" "noatime" "uid=1000" "nofail" ];
  # };

}
