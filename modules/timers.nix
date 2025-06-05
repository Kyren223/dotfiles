{ config, pkgs, ... }: {

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

  ###########################################################################

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

  ###########################################################################

  systemd.timers."git-auto-mirror" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "1m";
        OnUnitActiveSec = "5h";
        Unit = "git-auto-mirror.service";
      };
  };

  sops.secrets.gitea-sync-token = { owner = "kyren"; };
  sops.secrets.github-mirror-token = { owner = "kyren"; };
  systemd.services."git-auto-mirror" = {
    script = "python $HOME/scripts/gitea.py";
    path = [
      (pkgs.python312.withPackages (pypkgs: [
        pypkgs.matplotlib
        pypkgs.pandas
        pypkgs.pygithub
      ]))
    ];
    environment = {
      GITEA_TOKEN_FILE = config.sops.secrets.gitea-sync-token.path;
      GITHUB_TOKEN_FILE = config.sops.secrets.github-mirror-token.path;
    };
    serviceConfig = { Type = "oneshot"; User = "kyren"; };
  };

}
