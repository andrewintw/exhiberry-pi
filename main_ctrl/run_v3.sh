#! /bin/sh

GPIO_PIN=23
PWM_OFF=0
PWM_ON=500

VIDEOPATH="/home/pi/Desktop/tz"
VIDEO_A_PATH=$VIDEOPATH/A.mp4
VIDEO_B_PATH=$VIDEOPATH/B.mp4

light_on () {
	$DO gpio mode $GPIO_PIN  PWM
	$DO gpio pwm  $GPIO_PIN  $PWM_ON
}

light_off () {
	$DO gpio mode $GPIO_PIN  PWM
	$DO gpio pwm  $GPIO_PIN  $PWM_OFF
}

play_video() {
	local vname="$1"
	$DO omxplayer -o hdmi --no-osd $vname
}

do_main () {
	#while true; do
	#	light_on
	#	play_video $VIDEO_A_PATH
	#	light_off
	#	play_video $VIDEO_B_PATH
	#done

	while true; 
	do
		for videos in $VIDEOPATH/*
		do
			if [ "$videos" = "$VIDEO_A_PATH" ]; then
				/home/pi/light_pwm_ctrl.sh blink-on &
				#light_on
			else
				/home/pi/light_pwm_ctrl.sh blink-off &
				#light_off
			fi
			xterm -fullscreen -fg white -bg black -e omxplayer -o local -r "$videos" >/dev/null
			xrefresh -display :0
		done
	done
}

do_main
