while true
do
    volume=$(pamixer --get-volume-human)  # Get the current volume in a human-readable format
    date_time=$(date +'%Y-%m-%d %I:%M:%S %p')
    battery=$(cat /sys/class/power_supply/BAT0/capacity)%
    battery_status=$(cat /sys/class/power_supply/BAT0/status)

    echo "$date_time | Battery: $battery $battery_status | Volume: $volume"
    sleep 1
done
