 #!/usr/bin/env bash
echo "󰓃 Analog|󰽰 Pro Audio"
read -r choice
[[ "$choice" == *Analog* ]] && pactl set-profile analog-stereo
[[ "$choice" == *Pro* ]] && pactl set-profile pro-audio

