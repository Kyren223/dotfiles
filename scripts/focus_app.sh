APP=$1
WID=$(xdotool search --class "$APP" | head -n 1)

if [ -z "$WID" ]; then
    nohup $APP &>/dev/null &
else
    xdotool windowactivate "$WID"
fi

