#!/usr/bin/env zsh
swaymsg -t get_inputs \
  | jq -r '.[] | select(.identifier|test("keyboard")) | .xkb_active_layout_name' \
  | head -n1 \
  | awk '{print toupper(substr($0,1,2))}'
