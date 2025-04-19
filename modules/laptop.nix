{ config, pkgs, ... }:

{

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

}
