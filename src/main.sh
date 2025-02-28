#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

micmute_path="/sys/devices/platform/asus-nb-wmi/leds/platform::micmute/brightness"
micmute_event=$(grep -E 'Handlers|asus-nb-wmi' /proc/bus/input/devices | grep -A1 'asus-nb-wmi' | grep -Eo 'event[0-9]+')
# 7c is the key value for KEY_F20 in event9
# Example:
# type 4 (EV_MSC), code 4 (MSC_SCAN), value 7c
micmute_key_value="value 7c"
# Using KEY_F20 repeats itself 2 times when the key is pressed
# Example:
# type 1 (EV_KEY), code 190 (KEY_F20), value 1
# -------------- SYN_REPORT ------------
# type 1 (EV_KEY), code 190 (KEY_F20), value 0
# -------------- SYN_REPORT ------------
# It can be verified by running `/dev/input/$micmute_event`

if [ ! -f "$micmute_path" ]; then
  echo "Unsupported Device."
  exit 1
fi

# This secures the change of the LED state for every micmute key press
evtest /dev/input/$micmute_event | while read line; do
  if echo "$line" | grep -q "$micmute_key_value"; then
    current_value=$(cat $micmute_path)
    new_value=$((1 - current_value))
    echo $new_value > $micmute_path
  fi
done
