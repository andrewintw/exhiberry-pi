#!/bin/sh

sudo systemctl disable omx-auto.service

cat <<EOF
Please run the command:

$ sudo reboot

EOF
