{ pkgs, ... }: {

  home.username = "kyren";
  home.homeDirectory = "/home/kyren";

  home.stateVersion = "24.05"; # DO NOT CHANGE

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".jdks/openjdk17".source = pkgs.openjdk17;
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  xdg.desktopEntries = {
    "WhatsAppp" = {
      name = "WhatsApp";
      genericName = "Unofficial WhatsApp client";
      exec = "WEBKIT_DISABLE_DMABUF_RENDERER=1 wasistlos %U";
      terminal = false;
      icon = "whatsapp";
      categories = [ "Application" "Network" "WebBrowser" ];
      settings = {
        Keywords = "chat;im;messaging;messenger;sms;whatsapp;whatsapp-desktop;whatsie;wasistlos;";
      };
    };
  };

  # home.file.".local/share/applications/kopia-mount.desktop".text = ''
  #   [Desktop Entry]
  #   Type=Application
  #   Name=Kopia Backup
  #   Exec=xdg-open /mnt/kopia
  #   Icon=folder
  #   Terminal=false
  #   X-UDISKS2-Show=true
  # '';

  # services.udiskie.automount = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
