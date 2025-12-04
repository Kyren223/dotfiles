{ pkgs, inputs, config, ... }: {

  imports = [
    inputs.sops-nix.nixosModules.sops
    ../modules/apps.nix
    ../modules/display.nix
    ../modules/networking.nix
    ../modules/development.nix
    ../modules/gaming.nix
    ../modules/secrets.nix
    ../modules/systemd.nix
    inputs.home-manager.nixosModules.default
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users = {
      "kyren" = import ./home.nix;
    };
  };

  users.users.kyren = {
    isNormalUser = true;
    description = "Kyren";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # Localization
  time.timeZone = "Asia/Hebron";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "C.UTF-8/UTF-8"
    "en_IL/UTF-8"
  ];

  # Fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      font-awesome
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      defaultFonts = {
        # serif = [  "Liberation Serif" "Vazirmatn" ];
        # sansSerif = [ "Ubuntu" "Vazirmatn" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };

  # Fix for noto color emoji not rendering in firefox-based browsers
  fonts.fontconfig.useEmbeddedBitmaps = true;

  # Allow sudo without a password if in "wheel" group.
  security.sudo.wheelNeedsPassword = false;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ]; # for windows fs

  # Nix Config
  system.stateVersion = "24.05"; # DO NOT CHANGE!
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true; # reduces nix store size

  nixpkgs.config = {
    packageOverrides = pkgs: {
      emojipin = import <emojipin> {
        config = config.nixpkgs.config;
      };
    };
  };

  # Enable dynamic linking of apps that are not in nixpkgs
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc # Fixes issues with neovim plugins not working

    glib

    # Fixes issues with running games (nallo's)
    wayland
    libxkbcommon
    libGL

    noto-fonts

    pkg-config
    xorg.libX11
    xorg.libxcb
    fontconfig
    freetype
    dbus

    xorg.libX11
    xorg.libXcursor
    xorg.libxcb
    xorg.libXi
    libxkbcommon
    libz 
  ];

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # ENable CUPS daemon for printing
  services.printing.enable = false;

  # Install Flatpak and Flathub
  services.flatpak.enable = true;

  # Enable openssh
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO7P9K9D5RkBk+JCRRS6AtHuTAc6cRpXfRfRMg/Kyren"
  ];

  # Enable KVM/QEMU virtualization
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["kyren"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd.qemu = {
    runAsRoot = true;
    ovmf.enable = true;
    # Fix, see https://www.reddit.com/r/NixOS/comments/11j9qf7/virtio_fs_with_virtmanager/
    vhostUserPackages = with pkgs; [ virtiofsd virtio-win pkgs.swtpm ];
  };
  environment.systemPackages = [
    pkgs.virtiofsd # For shared fs
    pkgs.virtio-win  # For using virtio stuff in windows I think?
    pkgs.swtpm # For being able to emulate TPM 2.0 (otherwise it errors)
  ];
  # Fix no internet in libvirt, see https://discourse.nixos.org/t/issues-with-virt-manager-default-network-down-in-nixos-25-11/66808/3
  networking.firewall.trustedInterfaces = [ "wlp5s0" "virbr0" ];

  services.syncthing.enable = true;
  services.syncthing = {
    group = "users";
    user = "kyren";
    dataDir = "/home/kyren";
    configDir = "/home/kyren/.config/syncthing";
  };
  systemd.tmpfiles.rules = [
    "d /home/kyren/.config/syncthing 0700 kyren users"
  ];

  # App image fix, see https://github.com/internxt/drive-desktop-linux/issues/80
  # Hopefully this also fixes the other errors with fuse, not just for internxt
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = pkgs: [
      pkgs.fuse
    ];
  };

  # From when I tried hyprland, might aswell keep this?
  # Fixes "The name org.freedesktop.UDisks2 was not provided by any .service files"
  # See https://www.reddit.com/r/NixOS/comments/1goziru/dolphin_on_hyprland/
  services.udisks2.enable = true;

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d030", MODE="0666", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0666", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d030", MODE="0666", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
}
