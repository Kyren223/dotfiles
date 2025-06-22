{ pkgs, ... }: {

  imports = [
    ./nvidia.nix
  ];

  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
    phoronix-test-suite
  ];

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

  fileSystems."/mnt/kopia" = {
    device = "none";
    fsType = "fuse";
    options = [ "noauto" "allow_other" "default_permissions" "fsname=kopia" "uid=1000" ];
  };

  # services.udev.enable = true;  # usually on by default
  # services.udev.extraRules = ''
  #   KERNEL=="kopia", ACTION=="add", ENV{ID_FS_TYPE}=="fuse.kopia", \
  #   ENV{ID_MOUNT_ID}="kopia-mount", ENV{ID_FS_LABEL}=="kopia", \
  #   SYMLINK+="kopia-mount"
  # '';
}
