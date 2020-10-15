#!/bin/bash
# Ref: https://raspberrypi.stackexchange.com/questions/56564/omxplayer-seamless-looping

VIDEOPATH="/home/pi/Desktop/video"

while true; 
do
	for videos in $VIDEOPATH/*
	do
		xterm -fullscreen -fg white -bg black -e omxplayer -b -o hdmi "$videos" >/dev/null
		xrefresh -display :0
    done
done
