#!/bin/bash

# Variables initialization
DOWNLOAD_URL="https://github.com/RavenEibu/asus-micmute-key-led-driver.git"
DOWNLOAD_DIR=/home/$LOGNAME/asus-micmute-key-led-driver
LED_MIC_PATH=/sys/devices/platform/asus-nb-wmi/leds/platform::micmute/brightness
SERVICE_FILE=/etc/systemd/system/asus-micmute-key-led-driver.service

# Checks on installation if the Asus Micmute Key Led Driver is supported on the device
# This assures that the script will not install and the script will not run on unsupported devices
check_led_support() {
	echo "Checking if the Asus Micmute Key LED Driver is supported..."
	if [ ! -f "$LED_MIC_PATH" ]; then
		echo "Sorry, unsupported Device."
		exit 1
	else
		echo "Asus Micmute Key LED Driver is supported."
	fi
}

copy_service_file() {
	echo "Copying the systemd service file..."
	# Copy the service file to /etc/systemd/system
	sudo cp $DOWNLOAD_DIR/services/asus-micmute-key-led-driver.service $SERVICE_FILE
	echo "Systemd service file copied to $SERVICE_FILE"
}

update_systemd_service() {
	# Create the systemd service file
	copy_service_file
	# Reload systemd, enable and start the service
	echo "Reloading systemd, enabling and starting the service..."
	sudo systemctl daemon-reload
	sudo systemctl enable --now asus-micmute-key-led-driver.service
}

remove_systemd_service() {
	# Stop and disable the systemd service
	echo "Stopping and disabling the service..."
	sudo systemctl stop asus-micmute-key-led-driver.service
	sudo systemctl disable asus-micmute-key-led-driver.service

	# Remove the systemd service file
	echo "Removing the systemd service file..."
	sudo rm -f $SERVICE_FILE

	# Reload systemd
	sudo systemctl daemon-reload
}

install() {
	# Check if the Asus Micmute Key Led Driver is installed for update
	if [ -d "/opt/asus-micmute-key-led-driver" ]; then
		is_installed=true
	fi

	# This line outputs a message indicating that the script needs to have elevated privileges
	# for the Asus Micmute Key LED Driver installation, giving a brief explanation of the process.
	echo "Please elevate privileges to change the permissions for the Asus Micmute Key LED Driver Installer for:"
	echo " - Creating a folder in /opt in which the Asus Micmute Key LED Driver will be installed."
	echo " - Creating a systemd service for the Asus Micmute Key LED Driver."
	echo "You will be prompted for your password."

	# Clone the repository
	echo "Cloning the repository..."
	git clone -q "$DOWNLOAD_URL" "$DOWNLOAD_DIR"
	update_systemd_service

	# Copy all files from $DOWNLOAD_DIR to /opt/asus-micmute-key-led-driver
	echo "Copying files from $DOWNLOAD_DIR to /opt/asus-micmute-key-led-driver..."
	sudo mkdir -p /opt/asus-micmute-key-led-driver
	cp -r "$DOWNLOAD_DIR"/* /opt/asus-micmute-key-led-driver/
	# Remove the download directory
	echo "Removing the download directory..."
	rm -rfd "$DOWNLOAD_DIR"
	printf "\n"
	# Check if the Asus Micmute Key Led Driver is installed to change the output message accordingly
	if [ "$is_installed" = true ]; then
		echo "Asus Micmute Key LED Driver Updated."
	else
		echo "Asus Micmute Key LED Driver Installed."
		echo "It will start automatically from now and on boot."
		printf "\n"
		echo "You can check the service ran succesfully by running 'sudo systemctl status asus-micmute-key-led-driver'."
		echo "All files from the Asus Micmute Key LED Driver are located in /opt/asus-micmute-key-led-driver."
	fi
	printf "\n"
	echo "Enjoy!"
}

uninstall() {
	# Check if the Asus Micmute Key Led Driver is installed
	echo "Checking if the Asus Micmute Key Led Driver is installed..."
	if [ ! -d "/opt/asus-micmute-key-led-driver" ]; then
		echo "Asus Micmute Key Led Driver is not installed."
		exit 1
	fi

	echo "Please elevate privileges to change the permissions for the Asus Micmute Key LED Driver Installer for:"
	echo " - Removing folder in /opt in which the Asus Micmute Key LED Driver is installed."
	echo " - Removing the systemd service for the Asus Micmute Key LED Driver."
	echo "You will be prompted for your password."

	# Remove the /opt/asus-micmute-key-led-driver directory
	echo "Removing the /opt/asus-micmute-key-led-driver directory..."
	if [ -d "/opt/asus-micmute-key-led-driver" ]; then
		sudo rm -rf "/opt/asus-micmute-key-led-driver"
	else
		echo "Warning: /opt/asus-micmute-key-led-driver does not exist."
	fi

	# Remove the systemd service
	echo "Removing the systemd service..."
	remove_systemd_service

	# Confirm uninstallation
	printf "\n"
	echo "Asus Micmute Key Led Driver Uninstalled."
}

echo "Welcome to Asus Micmute Key Led Driver Installer/Uninstaller"
# Check if the Asus Micmute Key Led Driver is supported
check_led_support
echo "What would you like to do?"
echo "1) Install / Update"
echo "2) Uninstall"
echo "3) Exit"
echo "Enter your choice [1-3]:"
read choice
case $choice in
	1)
		install ;;
	2)
		uninstall ;;
	3)
		echo "Exiting..."
		exit 0
		;;
	*)
		echo "Invalid option. Please select a valid option."
		exit 1
		;;
esac
