{ config, pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kyren-laptop";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Optimize  nix store automatically
  nix.settings.auto-optimise-store=true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Hebron";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "C.UTF-8/UTF-8"
    "en_IL/UTF-8"
  ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow sudo without a password if in "wheel" group.
  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kyren = {
    isNormalUser = true;
    description = "Kyren";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs; };
    useUserPackages = true;
    useGlobalPkgs = true;
    users = {
      "kyren" = import ./home.nix;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Install firefox.
  programs.firefox.enable = true;

  programs.zsh.enable = true;

  # Install Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Install Docker (without using root access)
  # virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # List packages installed in system profile. Use for apps that need sudo.
  environment.systemPackages = with pkgs; [
    glib-networking
    openssl
    clang
    clang-tools
    ghostty
    glibcLocales
  ];

  # Enable dynamic linking of applications that are not in nixpkgs (for vim LSPs for example).
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Install Flatpak and Flathub
  services.flatpak.enable = true;

  # Enable openssh
  services.openssh.enable = true;

  # Mouse config service (used with piper)
  services.ratbagd.enable = true;

  # battery levels notifier
  systemd.timers."battery-notifier" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "3m";
        OnUnitActiveSec = "3m";
        Unit = "battery-notifier.service";
      };
  };

  systemd.services."battery-notifier" = {
    script = "$HOME/scripts/battery_notifier.sh";
    serviceConfig = {
      Type = "oneshot";
      User = "kyren";
    };
  };

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
    serviceConfig = {
      Type = "oneshot";
      User = "kyren";
    };
  };

  # Enable KVM/QEMU virtualization
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["kyren"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
