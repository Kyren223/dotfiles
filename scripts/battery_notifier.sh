set -eu
export DISPLAY=:0.0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus

battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
battery_status=$(cat /sys/class/power_supply/BAT0/status)

if [ "$battery_status" = "Charging" ] && [ "$battery_level" -ge 80 ]; then
    /etc/profiles/per-user/kyren/bin/notify-send --urgency=critical \
      --app-name="Battery Notifier" \
      --expire-time=5000 \
      "Battery at $battery_level%, unplug!"
fi
