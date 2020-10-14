
#!/bin/bash
VIDEOPATH="/home/pi/Desktop/a_maidens_prayer_1010_A+B"

while true; 
do
	for videos in $VIDEOPATH/*
	do
		xterm -fullscreen -fg white -bg black -e omxplayer -o hdmi -r "$videos" >/dev/null
		xrefresh -display :0
    done
done
