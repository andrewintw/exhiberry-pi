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

kill_process() {
	local st="$1"
	local pid=''

	pid=`ps aux | grep python | grep "$st" | head -n 1 | awk '{print $2}'`
	if [ "$pid" != "" ]; then
		sudo kill -9 $pid
	fi
}

do_init () {
	$DO python /home/pi/pwm_ctrl.py "off" &
    sleep 2
	kill_process "off"
}

do_main () {
	local pos=0

	do_init

	omxplayer -b  --no-keys -o local --no-osd  $VIDEO_PATH --loop &
	while true; 
	do
		pos=`dbus_get_pos`

		if   [[ "$pos" -gt 0 && "$pos" -lt "$POS_LIGHT_BLINK1_END" && "$light_stat" = "4" ]]; then
			echo "${pos}: trigger blink1"
			python /home/pi/pwm_ctrl.py blink &
			kill_process "off"
			light_stat=1
		elif [[ "$pos" -gt "$POS_LIGHT_BLINK1_END"   && "$pos" -lt "$POS_LIGHT_BLINK2_START" && "$light_stat" = "1" ]]; then
			echo "${pos}: trigger on"
			python /home/pi/pwm_ctrl.py on &
			kill_process "blink"
			light_stat=2
		elif [[ "$pos" -gt "$POS_LIGHT_BLINK2_START" && "$pos" -lt "$POS_LIGHT_OFF_START" && "$light_stat" = "2" ]]; then
			echo "${pos}: trigger blink2"
			python /home/pi/pwm_ctrl.py blink &
			kill_process "on"
			light_stat=3
		elif [[ "$pos" -gt "$POS_LIGHT_OFF_START" && "$light_stat" = "3" ]]; then
			echo "${pos}: trigger off"
			python /home/pi/pwm_ctrl.py off &
			kill_process "blink"
			light_stat=4
		else
			echo "${pos}"
		fi
		sleep 0.5
	done
}

do_main

