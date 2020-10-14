#! /bin/sh

GPIO_PIN=23
PWM_BLINK="$1"

light_blink () {
	$DO gpio mode $GPIO_PIN  PWM
	$DO gpio pwm  $GPIO_PIN  $PWM_BLINK
}

light_blink
