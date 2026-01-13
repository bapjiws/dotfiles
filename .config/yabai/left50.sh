#!/bin/bash
if yabai -m query --windows --window | jq -e '.["is-floating"]' | grep -q true; then
    yabai -m window --grid 1:2:0:0:1:1
else
    yabai -m window --toggle float && yabai -m window --grid 1:2:0:0:1:1
fi
