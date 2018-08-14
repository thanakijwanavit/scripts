#!/usr/bin/env python3


def kaku(sum, length):
	data= []
	for j in range(0,length):
		data.append(1)
	for i in range(1,9):
		for k in range(0,len(data)):
			total = sum(data)
		print(total)


kaku(4,4)
