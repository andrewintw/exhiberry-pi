#! /bin/sh

GPIO_PIN=23
PWM_OFF=0
PWM_ON=500

VIDEO_A_PATH=/home/pi/Desktop/a_maidens_prayer_1010_A+B/a_maidens_prayer_1010-partA.mp4
VIDEO_B_PATH=/home/pi/Desktop/a_maidens_prayer_1010_A+B/a_maidens_prayer_1010-partB.mp4

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
	while true; do
		light_on
		play_video $VIDEO_A_PATH
		light_off
		play_video $VIDEO_B_PATH
	done
}

do_main
