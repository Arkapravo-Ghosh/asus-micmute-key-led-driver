#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

micmute_path="/sys/devices/platform/asus-nb-wmi/leds/platform::micmute/brightness"
micmute_event=$(grep -E 'Handlers|asus-nb-wmi' /proc/bus/input/devices | grep -A1 'asus-nb-wmi' | grep -Eo 'event[0-9]+')
micmute_key_code="KEY_F20"

if [ ! -f "$micmute_path" ]; then
  echo "Unsupported Device."
  exit 1
fi

while true; do
  if evtest /dev/input/$micmute_event | grep -q "$micmute_key_code"; then
    tee $micmute_path <<< $((1 - $(cat $micmute_path)))
  fi
done
