'''
Control the Brightness of LED using PWM on Raspberry Pi
Ref: http://www.electronicwings.com
'''

import sys
import random
import RPi.GPIO as GPIO
from time import sleep

ledpin=12 # PWM pin connected to LED
duty_on=100
duty_off=0

def pwm_ctrl(cmd):
    GPIO.setwarnings(False)			#disable warnings
    GPIO.setmode(GPIO.BOARD)		#set pin numbering system
    GPIO.setup(ledpin,GPIO.OUT)
    pi_pwm = GPIO.PWM(ledpin,1000)	#create PWM instance with frequency
    pi_pwm.start(0)					#start PWM of required Duty Cycle 
    if cmd == 'on':
        while True:
            pi_pwm.ChangeDutyCycle(duty_on)
            sleep(0.01)
    elif cmd == 'off':
        while True:
            pi_pwm.ChangeDutyCycle(duty_off)
            sleep(0.01)
    elif cmd == 'blink':
        while True:
            delay = [0.03, 0.04, 0.05, 0.06, 0.07, 0.08]
            pi_pwm.ChangeDutyCycle(duty_on)
            sleep(random.choice(delay))
            pi_pwm.ChangeDutyCycle(duty_off)
            sleep(random.choice(delay))

def main():
    pwm_ctrl(sys.argv[1])
 
if __name__ == "__main__":
    main()
