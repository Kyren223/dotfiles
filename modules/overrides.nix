{ pkgs-emoji-pin, ... }: {

  environment.systemPackages = with pkgs-emoji-pin; [
    noto-fonts-color-emoji
    librewolf
    # vim
  ];

}
