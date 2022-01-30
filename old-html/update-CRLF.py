#!/usr/bin/python

import os
import codecs
import string
import re

def justify_CRLF(path):
	f_in  = codecs.open(path, 'r', 'utf-8')
	try:
		lines = f_in.readlines()
	except:
		print "error on reading " + path
		raise
	f_in.close()

	f_out  = codecs.open(path, 'w', 'utf-8')
	for line in lines:
		line = line.replace('\r', '')
		line = line.replace('\n', '')
		f_out.write(line + '\r\n')
	f_out.close()

scriptdir = os.path.dirname(os.path.realpath(__file__))
for dirpath, dirnames, filenames in os.walk(scriptdir):
	for file in filenames:
		if file.endswith('.html'):
			path = os.path.join(dirpath, file)
			justify_CRLF(path)
