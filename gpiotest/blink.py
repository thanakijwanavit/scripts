#!/usr/bin/python3

#please connect an led negative terminal to the pin 12 and positive to
#3.3V output pin
#make sure resistor is added

#import necessary libraries
import RPi.GPIO as GPIO
import time
import sys



#gpio setup
GPIO.setmode(GPIO.BOARD)
GPIO.setup(12,GPIO.OUT)


#blink
loop=1
while loop==1:
	print('loop is on')
	for i in range(0,10):
		GPIO.output(12,0)
		print('the led should be on')
		time.sleep(1)
		GPIO.output(12,1)
		print('the led should be off')
		time.sleep(1)
	print('loop is off')
	print('continue looping?')
	i=input()
	if i=='yes':
		loop=1
	else:
		loop=0


print('loop is broken')
GPIO.cleanup()
print('GPIO is cleaned')
sys.exit(1)
