{ pkgs, inputs, ... }: {

  imports = [
    ../modules/apps.nix
    ../modules/kde.nix
    ../modules/networking.nix
    ../modules/development.nix
    ../modules/gaming.nix
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
    extraGroups = [ "networkmanager" "wheel" ];
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

  # Enable dynamic linking of apps that are not in nixpkgs
  # Fixes issues with neovim plugins not working
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
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
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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
  };
  environment.systemPackages = [ pkgs.virtiofsd ]; # For shared fs

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

  systemd.timers."git-auto-sync" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "5m";
        Unit = "git-auto-sync.service";
      };
  };

  systemd.services."git-auto-sync" = {
    script = "$HOME/scripts/git-auto-sync.sh";
    path = [
      pkgs.git
      pkgs.gh
      pkgs.keychain
      pkgs.openssh
    ];
    serviceConfig = { Type = "oneshot"; User = "kyren"; };
  };

  systemd.timers."k-sleep-tracker" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = "1m";
        Unit = "k-sleep-tracker.service";
      };
  };

  systemd.services."k-sleep-tracker" = {
    script = "$HOME/projects/k/bin/k tracker sleep";
    serviceConfig = { Type = "oneshot"; User = "kyren"; };
  };

}
