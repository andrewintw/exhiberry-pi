#!/bin/sh

if [ ! -f "/home/pi/omx-auto.service" ]; then
	echo "There is NO /home/pi/omx-auto.service"
	exit 1
fi

sudo cp /home/pi/omx-auto.service /lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable omx-auto.service

cat <<EOF
Please run the command:

$ sudo reboot

EOF
