set -eu
export DISPLAY=:0.0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus

battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
battery_status=$(cat /sys/class/power_supply/BAT0/status)
echo "Battery: $battery_level% $battery_status" >> "$HOME/Desktop/debug.log"

if [ "$battery_status" = "Charging" ] && [ "$battery_level" -ge 80 ]; then
    echo "Notification sent" >> "$HOME/Desktop/debug.log"
    /etc/profiles/per-user/kyren/bin/notify-send --urgency=normal \
      --app-name="Battery Notifier" \
      --expire-time=5000 \
      "Battery at $battery_level%, unplug!" >>  "$HOME/Desktop/debug.log" 2>&1
fi
