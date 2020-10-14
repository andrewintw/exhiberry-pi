#! /bin/sh

GPIO_PIN=1
PWM_OFF=0
PWM_ON=500
PWM_BLINK=199

VIDEOPATH="/home/pi/Desktop/tz"
VIDEO_PATH=$VIDEOPATH/full.mp4

#             blink1_end     blink2_start      off_start
#                   |              |              |
#    |--- blink1 ---|----- on -----|--- blink2 ---|--- off ---|
#  00:00          00:10          00:25          00:30       xx:xx

POS_LIGHT_BLINK1_END=10000000
POS_LIGHT_BLINK2_START=387000000
POS_LIGHT_OFF_START=397000000

OMXPLAYER_DBUS_ADDR="/tmp/omxplayerdbus.${USER:-root}"                                                                                                                 
OMXPLAYER_DBUS_PID="/tmp/omxplayerdbus.${USER:-root}.pid"

# light stat { 1:blink1, 2:on, 3:blink2, 4:off }
light_stat=4

light_init () {
	echo "set GPIO${GPIO_PIN} to PWM mode"
	$DO gpio mode $GPIO_PIN pwm
}

light_ctrl () {
	local pwm_val="$1"
	echo "set GPIO${GPIO_PIN} PWM level to $pwm_val"
 light_init  
	$DO gpio pwm $GPIO_PIN $pwm_val
}

play_video() {
	local vname="$1"
	$DO omxplayer -o hdmi --no-osd $vname
}

dbus_get_pos() {
	export DBUS_SESSION_BUS_ADDRESS=`cat $OMXPLAYER_DBUS_ADDR`
	export DBUS_SESSION_BUS_PID=`cat $OMXPLAYER_DBUS_PID`
	#[ -z "$DBUS_SESSION_BUS_ADDRESS" ] && { echo "Must have DBUS_SESSION_BUS_ADDRESS" >&2; exit 1; }
	[ -z "$DBUS_SESSION_BUS_ADDRESS" ] && { echo "Must have DBUS_SESSION_BUS_ADDRESS" >&2; }

	position=`dbus-send --print-reply=literal --session --reply-timeout=500 --dest=org.mpris.MediaPlayer2.omxplayer /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:"org.mpris.MediaPlayer2.Player" string:"Position" 2>/dev/null`

	#[ $? -ne 0 ] && exit 1

	if [ $? -eq 0 ]; then
		position="$(awk '{print $2}' <<< "$position")"
		echo "$position"
	fi
}

do_main () {
	local pos=0

	#light_init

	#omxplayer -b -r --no-keys -o local --no-osd $VIDEO_PATH --loop &
	omxplayer -b  --no-keys -o local --no-osd  $VIDEO_PATH --loop &

	while true; 
	do
		pos=`dbus_get_pos`

		if   [[ "$pos" -gt 0 && "$pos" -lt "$POS_LIGHT_BLINK1_END" && "$light_stat" = "4" ]]; then
			echo "${pos}: trigger blink1"
			light_ctrl $PWM_BLINK        
			light_stat=1
		elif [[ "$pos" -gt "$POS_LIGHT_BLINK1_END"   && "$pos" -lt "$POS_LIGHT_BLINK2_START" && "$light_stat" = "1" ]]; then
			echo "${pos}: trigger on"
			light_ctrl $PWM_ON
			light_stat=2
		elif [[ "$pos" -gt "$POS_LIGHT_BLINK2_START" && "$pos" -lt "$POS_LIGHT_OFF_START" && "$light_stat" = "2" ]]; then
			echo "${pos}: trigger blink2"
			light_ctrl $PWM_BLINK
			light_stat=3
		elif [[ "$pos" -gt "$POS_LIGHT_OFF_START" && "$light_stat" = "3" ]]; then
			echo "${pos}: trigger off"
			light_ctrl $PWM_OFF
			light_stat=4
		else
			echo "${pos}"
		fi
		sleep 0.5
	done
}

do_main

