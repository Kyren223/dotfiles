if xdotool search --class "firefox" getwindowname %@ | grep -q "firefox"; then
if xdotool search --onlyvisible --class "firefox" windowactivate %@; then
    echo "firefox is focused. Minimizing."
    xdotool search --onlyvisible --class "firefox" windowminimize %@
else
    echo "firefox is open but not focused. Focusing the existing instance."
    xdotool search --class "firefox" windowactivate %@
fi

