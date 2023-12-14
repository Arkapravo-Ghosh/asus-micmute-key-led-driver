#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root."
  exit 1
fi

download_url="https://github.com/Arkapravo-Ghosh/asus-micmute-key-led-driver.git"
install_dir="/opt/asus-micmute-key-led-driver"

if [ -d "$install_dir" ]; then
  cd "$install_dir"
  git config pull.rebase true
  git -C "$install_dir" pull
  cp "$install_dir/services/asus-micmute-key-led-driver.service" /etc/systemd/system/
  systemctl daemon-reload
  systemctl enable --now asus-micmute-key-led-driver.service
  echo "Updated ASUS Mic Mute Key LED Driver."
  cd -
  exit 0
fi

git clone "$download_url" "$install_dir"
cp "$install_dir/services/asus-micmute-key-led-driver.service" /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now asus-micmute-key-led-driver.service
echo "Installed ASUS Mic Mute Key LED Driver."