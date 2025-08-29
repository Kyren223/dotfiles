{ pkgs, lib, inputs, ... }:
with lib; let
  hyprPluginPkgs = inputs.hyprland-plugins.packages.${pkgs.system};
  hypr-plugin-dir = pkgs.symlinkJoin {
    name = "hyrpland-plugins";
    paths = with hyprPluginPkgs; [
      hyprbars
    ];
  };
in {

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  environment.sessionVariables = {
    HYPR_PLUGIN_DIR = hypr-plugin-dir;
  };

  xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;

      extraPortals = with pkgs; [
          kdePackages.xdg-desktop-portal-kde
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
      ];

      config = {
          hyprland = {
              default = [ "hyprland" "gtk" ];
              # "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
              "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
          };
      };
  };

  # Optional, hint electron apps to use wayland:
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # services.displayManager.sddm.settings = {
  #   Autologin = {
  #     Session = "plasma.desktop";
  #     User = "kyren";
  #   };
  # };
  #
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;
  #
  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "";
  # };

}
