{ pkgs-emoji-pin, ... }: {

  environment.systemPackages = [
    pkgs-emoji-pin.noto-fonts-color-emoji
    pkgs-emoji-pin.librewolf
  ];

}
