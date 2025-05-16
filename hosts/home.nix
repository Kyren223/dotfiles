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
    "com.ktechpit.whatsie" = {
      name = "WhatsApp";
      genericName = "Watsie, unofficial WhatsApp client";
      exec = "whatsie %U";
      terminal = false;
      icon = "com.github.eneshecan.WhatsAppForLinux";
      categories = [ "Application" "Network" "WebBrowser" ];
      settings = {
        Keywords = "chat;im;messaging;messenger;sms;whatsapp;whatsapp-desktop;whatsie;";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
