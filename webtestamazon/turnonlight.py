#!/usr/bin/env python3
import requests


def on():
	requests.get('http://10.0.1.169/turnledon')

def off():
	requests.get('http://10.0.1.169/turnledoff')

'''while True:
	usercommand = input('on or off\n')
	if usercommand == 'on':
		on()
	elif usercommand == 'off':
		off()
	else:
		print('press on or off')
		continue
'''
