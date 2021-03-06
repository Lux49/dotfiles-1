#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done

export POLY_WLAN=$(ip a | rg '^\d*:\s(w.*?):.*BROADCAST.*' -r '$1')
export POLY_ETH=$(ip a | rg '^\d*:\s(e.*?):.*BROADCAST.*' -r '$1')

# Launch bars, based on xrandr output
xrandr | grep '\bconnected\b' | \
    while read -r output state rest; do
        if [[ $rest == *primary* ]]; then
            bar=primary
        else
            bar=secondary
        fi
        POLY_MONITOR=$output polybar $bar &
    done

echo "Bars launched..."
