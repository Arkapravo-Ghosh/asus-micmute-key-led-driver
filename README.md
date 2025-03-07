# ASUS Mic Mute Key LED Driver

![Sample Image](docs/assets/micmute-led-sample.jpg)

## Explanation

This script is created for ASUS Vivobooks which use [asus-nb-wmi](https://github.com/torvalds/linux/blob/master/drivers/platform/x86/asus-nb-wmi.c).
This is a kernel module that is included in the Linux kernel and is loaded automatically on ASUS laptops.

This repository creates a service that runs a script using the events in `evtest /dev/input/eventN` to check every update on the mic mute key.
The eventN has a random value ranging from 0 to N for every input device. This script searches the events of the Asus WMI hotkeys for the key
identifier (in the kernel module with a value of 0x7c) of the mute key and changes the value of the
`/sys/devices/platform/asus-nb-wmi/leds/platform::micmute/brightness` to turn on or turn off the LED of the mic mute key.

## Prerequisites

- [evtest](https://gitlab.freedesktop.org/libevdev/evtest)

## Install - Uninstall

- Run the following command in your terminal:

```bash
bash <(curl -s https://raw.githubusercontent.com/RavenEibu/asus-micmute-key-led-driver/main/installer.sh
```

Boom! You're done! 🎉
