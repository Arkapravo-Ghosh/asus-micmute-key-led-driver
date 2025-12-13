#!/bin/bash

micmute_path="/sys/devices/platform/asus-nb-wmi/leds/platform::micmute/brightness"
micmute_event=$(grep -E 'Handlers|asus-nb-wmi' /proc/bus/input/devices | grep -A1 'asus-nb-wmi' | grep -Eo 'event[0-9]+')
# 7c is the key value for KEY_F20 in event input
# Reffer to https://github.com/torvalds/linux/blob/master/drivers/platform/x86/asus-nb-wmi.c - Line 594
micmute_key_value="value 7c"

# This secures the change of the LED state for every micmute key press
evtest /dev/input/$micmute_event | while read line; do
  if echo "$line" | grep -q "$micmute_key_value"; then
    current_value=$(cat $micmute_path)
    new_value=$((1 - current_value))
    echo $new_value > $micmute_path
  fi
done
