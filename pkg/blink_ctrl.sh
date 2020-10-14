#! /bin/sh

GPIO_PIN=23
PWM_OFF=0
PWM_ON=500
PWM_BLINK=196

op="$1"

light_on () {
	$DO gpio mode $GPIO_PIN  PWM
	$DO gpio pwm  $GPIO_PIN  $PWM_ON
}

light_off () {
	$DO gpio mode $GPIO_PIN  PWM
	$DO gpio pwm  $GPIO_PIN  $PWM_OFF
}

light_blink () {
	$DO gpio mode $GPIO_PIN  PWM
	$DO gpio pwm  $GPIO_PIN  $PWM_BLINK
}

do_main () {
	if [ "$op" = "" ]; then
		cat <<EOF
Usage: $0 <on | off | blink | blink-on | blink-off>
EOF
	fi
	case $op in
		"on")
			light_on
			;;
		"off")
			light_off
			;;
		"blink")
			light_blink
			;;
		"blink-on")
			light_blink
			sleep 10
			light_on
			;;
		"blink-off")
			light_blink
			sleep 10
			light_off
			;;

	esac
}


do_main
