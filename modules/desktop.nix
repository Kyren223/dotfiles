{ pkgs, ... }:
{

  imports = [
    # ./nvidia.nix
  ];

  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
    phoronix-test-suite

    libsodium # Needed for webzfs, seems to be a python crypto library
    libsodium.dev
    libsodium.out
    python313Packages.libnacl
  ];

  users.groups.webzfs = { };
  users.users.webzfs = {
    isNormalUser = true;
    password = "";
  };

  hardware.keyboard.qmk.enable = true;
  services.udev.extraRules = ''
    # Match ANY Keychron device via hidraw (covers Q1 HE in all modes)
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", MODE="0666", TAG+="uaccess", TAG+="udev-acl"

    # STM bootloader for flashing firmware
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0666", TAG+="uaccess"
  '';

  security.sudo.extraRules = [
    {
      users = [ "webzfs" ];
      commands = [
        {
          command = "/nix/store/*-zfs-user-*/bin/zpool";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/nix/store/*-zfs-user-*/bin/zfs";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
  security.sudo.extraConfig = ''
    Defaults env_reset,always_set_home,secure_path="/run/current-system/sw/bin:/run/wrappers/bin:/nix/store"
    Defaults secure_path="/run/current-system/sw/bin:/bin:/usr/bin"
    Defaults env_reset
    Defaults ignore_dot
    Defaults !requiretty
  '';
  environment.etc."sudoers.d/webzfs".text = ''
    # WebZFS sudo permissions
    # Allow webzfs user to execute ZFS and SMART commands

    # ZFS commands (multiple paths for different distributions)
    webzfs ALL=(ALL) NOPASSWD: zpool, zfs, zdb -l *, /run/current-system/sw/bin/zpool

    # SMART monitoring (multiple paths for different distributions)
    webzfs ALL=(ALL) NOPASSWD: smartctl

    # Disk utilities
    webzfs ALL=(ALL) NOPASSWD: blkid

    # Sanoid/Syncoid (optional)
    webzfs ALL=(ALL) NOPASSWD: sanoid, syncoid

    # Service management (systemctl for system services page)
    webzfs ALL=(ALL) NOPASSWD: systemctl

    # Crontab editing
    webzfs ALL=(ALL) NOPASSWD: crontab

    # File editing (for config files like smartd.conf, sanoid.conf)
    webzfs ALL=(ALL) NOPASSWD: mkdir

    # Read system journal and plain-text syslog files for the
    # Observability -> System Log page. journalctl needs sudo (or
    # systemd-journal group) on most distros. tail covers Debian/Ubuntu
    # (/var/log/syslog) and old RHEL (/var/log/messages).
    webzfs ALL=(ALL) NOPASSWD: tail
  '';

  systemd.units."webzfs.service".text = ''
    [Unit]
    Description=WebZFS Web Management Interface
    After=network.target zfs-mount.service

    [Service]
    Type=notify
    User=root
    Group=root
    WorkingDirectory=/opt/webzfs
    Environment="PATH=/opt/webzfs/.venv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/run/current-system/sw/bin:/sbin:/bin"
    ExecStart=/opt/webzfs/.venv/bin/gunicorn -c config/gunicorn.conf.py
    Restart=always
    RestartSec=5

    # Runtime directory for unix socket support
    # Creates /run/webzfs/ on service start, removes on stop
    # To use: set BIND=unix:/run/webzfs/webzfs.sock in .env
    RuntimeDirectory=webzfs
    RuntimeDirectoryMode=0755

    [Install]
    WantedBy=multi-user.target
  '';

  # Automaticaly mount C drive
  fileSystems."/mnt/c" = {
    device = "/dev/nvme1n1p4";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "noatime"
      "uid=1000"
      "nofail"
    ];
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
